#include <memory>
#include <verilated.h>
#include "verilated_vcd_c.h" //可选，如果要导出wave则需要加上
#include "Vtop_tb.h"    // Verilog模块会被编译成Vxxx

int main(int argc, char **argv, char **env){

    // Construct a VerilatedContext to hold simulation time, etc.
    // Multiple modules (made later below with Vtop) may share the same
    // context to share time, or modules may have different contexts if
    // they should be independent from each other.

    // Using unique_ptr is similar to
    // "VerilatedContext* contextp = new VerilatedContext" then deleting at end.
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs argument parsing
    contextp->debug(0);

    // Randomization reset policy
    // May be overridden by commandArgs argument parsing
    contextp->randReset(2);


    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    contextp->commandArgs(argc, argv);
    
    const std::unique_ptr<Vtop_tb> top{new Vtop_tb{contextp.get(), "top_tb"}};

#if VM_TRACE
    VerilatedVcdC* tfp = nullptr;
    const char* flag = contextp->commandArgsPlusMatch("trace");
    if (flag && 0 == strcmp(flag, "+trace")) {
        contextp->traceEverOn(true);
        VL_PRINTF("Enabling waves into wave.vcd...\n");
        tfp = new VerilatedVcdC;
        top->trace(tfp, 99);
        tfp->open("wave.vcd");
    }

    // VerilatedFstC* tfp = nullptr;
    // const char* flag = contextp->commandArgsPlusMatch("trace");
    // if (flag && 0 == strcmp(flag, "+trace")) {
    //     contextp->traceEverOn(true);
    //     VL_PRINTF("Enabling waves into wave.fst...\n");
    //     tfp = new VerilatedFstC;
    //     top->trace(tfp, 99);
    //     tfp->open("wave.fst");
    // }


#endif
    int sim_time = 2000;
    top->clk = 0;
    // Simulate until $finish
    while (contextp->time() < sim_time && !contextp->gotFinish()) { 
        // Historical note, before Verilator 4.200 Verilated::gotFinish()
        // was used above in place of contextp->gotFinish().
        // Most of the contextp-> calls can use Verilated:: calls instead;
        // the Verilated:: versions simply assume there's a single context
        // being used (per thread).  It's faster and clearer to use the
        // newer contextp-> versions.

        contextp->timeInc(1);  // 1 timeprecision period passes...
        // Historical note, before Verilator 4.200 a sc_time_stamp()
        // function was required instead of using timeInc.  Once timeInc()
        // is called (with non-zero), the Verilated libraries assume the
        // new API, and sc_time_stamp() will no longer work.

        top->clk = ~top->clk & 0x1;
        //? VL_PRINTF("[%" PRId64 "] vlt running...\n", contextp->time());

        if (!top->clk) {
            if (contextp->time() > 1 && contextp->time() < 10) {
                top->rst = 1;  // Assert reset
            } else {
                top->rst = 0;  // Deassert reset
            }
        }

        // Evaluate model
        // (If you have multiple models being simulated in the same
        // timestep then instead of eval(), call eval_step() on each, then
        // eval_end_step() on each. See the manual.)
        top->eval(); 
#if VM_TRACE
        if (tfp) tfp->dump(contextp->time());
#endif

    }



    top->final();

    // Close trace if opened
#if VM_TRACE
    if (tfp) {
        tfp->close();
        tfp = nullptr;
    }
#endif

    return 0;
}
