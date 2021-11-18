# PL06

**Data**: 18-11-2021

## Informações sobre o aluno

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

---

## Resolução de Exercícios

### **1.** `Critical`, `atomic` and `Reduction` directives

#### **a)** Measure the code scalability by comparing `critical`, `atomic` and `reduction` directives to avoid the data race in the shared variable (`mypi`). To obtain the execution times of your code use `sbatch --partition=cpar time.sh`


| Directive | Texec (ms) | 
| :-:       | :-:        |
| Critical  | 4120       |
| Atomic    | 837        |
| Redution  | 13         |

#### **b)** Analyse the time overhead of the critical directive using the perf tool. Adapt the script `perf1.sh` for your case.

```
# To display the perf.data header info, please use --header/--header-only options.
#
#
# Total Lost Samples: 26
#
# Samples: 725K of event 'cycles:ppp'
# Event count (approx.): 514026233745
#
# Overhead       Samples  Command  Shared Object       Symbol                                        
# ........  ............  .......  ..................  ..............................................
#
    76.36%        552866  a.out    libgomp.so.1.0.0    [.] 0x0000000000018418
    10.96%         79413  a.out    libgomp.so.1.0.0    [.] 0x0000000000018515
     4.22%         30604  a.out    libgomp.so.1.0.0    [.] 0x000000000001842a
     2.28%         16457  a.out    libgomp.so.1.0.0    [.] 0x000000000001842c
     2.20%         15886  a.out    libgomp.so.1.0.0    [.] GOMP_critical_end
     1.58%         11447  a.out    libgomp.so.1.0.0    [.] GOMP_critical_start
     0.82%          5977  a.out    libgomp.so.1.0.0    [.] 0x000000000001841a
     0.26%          1908  a.out    libgomp.so.1.0.0    [.] 0x00000000000183f9
     0.20%          1470  a.out    a.out               [.] main._omp_fn.0
     0.10%           703  a.out    libgomp.so.1.0.0    [.] 0x0000000000018427
     0.08%           588  a.out    libgomp.so.1.0.0    [.] 0x000000000001850b
     0.08%           570  a.out    [kernel.kallsyms]   [k] retint_userspace_restore_args
     0.07%           489  a.out    libgomp.so.1.0.0    [.] 0x000000000001850d
     0.06%           338  a.out    libgomp.so.1.0.0    [.] 0x0000000000018b1f
     0.05%           364  a.out    [kernel.kallsyms]   [k] task_tick_fair
     0.04%          1599  a.out    [kernel.kallsyms]   [k] native_write_msr_safe
     0.03%           247  a.out    [kernel.kallsyms]   [k] hrtimer_active
     0.03%           186  a.out    [kernel.kallsyms]   [k] ktime_get
     0.03%           185  a.out    libgomp.so.1.0.0    [.] 0x00000000000183eb
     0.03%           185  a.out    [kernel.kallsyms]   [k] update_cfs_shares
     0.02%           171  a.out    [kernel.kallsyms]   [k] apic_timer_interrupt
     0.02%           155  a.out    libgomp.so.1.0.0    [.] 0x0000000000018508
     0.02%           148  a.out    [kernel.kallsyms]   [k] irq_return
     0.02%           138  a.out    [kernel.kallsyms]   [k] update_curr
     0.02%           144  a.out    libgomp.so.1.0.0    [.] 0x0000000000018b21
     0.02%           122  a.out    [kernel.kallsyms]   [k] intel_pstate_update_util
     0.01%           107  a.out    [kernel.kallsyms]   [k] scheduler_tick
     0.01%           104  a.out    libgomp.so.1.0.0    [.] 0x0000000000018c97
     0.01%           117  a.out    libgomp.so.1.0.0    [.] 0x0000000000018b10
     0.01%            96  a.out    [kernel.kallsyms]   [k] update_cfs_rq_blocked_load
     0.01%            91  a.out    [kernel.kallsyms]   [k] ktime_get_update_offsets_now
     0.01%            86  a.out    [kernel.kallsyms]   [k] tick_sched_timer
     0.01%            76  a.out    libgomp.so.1.0.0    [.] 0x0000000000018407
     0.01%            74  a.out    [kernel.kallsyms]   [k] read_tsc
     0.01%            73  a.out    libgomp.so.1.0.0    [.] 0x0000000000018c99
     0.01%            74  a.out    [kernel.kallsyms]   [k] _raw_qspin_lock
     0.01%            67  a.out    libgomp.so.1.0.0    [.] 0x0000000000018400
     0.01%            61  a.out    libgomp.so.1.0.0    [.] 0x0000000000018c88
     0.01%            61  a.out    [kernel.kallsyms]   [k] rcu_check_callbacks
     0.01%            60  a.out    [kernel.kallsyms]   [k] __calc_delta
     0.01%            63  a.out    [kernel.kallsyms]   [k] __x86_indirect_thunk_rax
     0.01%            53  a.out    [kernel.kallsyms]   [k] cpuacct_account_field
     0.01%            50  a.out    libgomp.so.1.0.0    [.] 0x000000000001851b
     0.01%            48  a.out    libgomp.so.1.0.0    [.] 0x0000000000018423
     0.01%            47  a.out    [kernel.kallsyms]   [k] __do_softirq
     0.01%            45  a.out    [kernel.kallsyms]   [k] __update_cpu_load
     0.01%            44  a.out    [kernel.kallsyms]   [k] perf_event_task_tick
     0.01%            43  a.out    [kernel.kallsyms]   [k] run_timer_softirq
     0.01%            42  a.out    libgomp.so.1.0.0    [.] 0x0000000000018519
     0.01%            38  a.out    libgomp.so.1.0.0    [.] 0x00000000000183f0
     0.01%            37  a.out    [kernel.kallsyms]   [k] hrtimer_interrupt
     0.00%            33  a.out    [kernel.kallsyms]   [k] __hrtimer_run_queues
     0.00%            33  a.out    [kernel.kallsyms]   [k] trigger_load_balance
     0.00%            32  a.out    [kernel.kallsyms]   [k] cpuacct_charge
     0.00%            32  a.out    a.out               [.] GOMP_critical_end@plt
     0.00%            31  a.out    [kernel.kallsyms]   [k] update_min_vruntime
     0.00%            31  a.out    [kernel.kallsyms]   [k] lapic_next_deadline
     0.00%            30  a.out    libgomp.so.1.0.0    [.] 0x0000000000018c8b
     0.00%            30  a.out    [kernel.kallsyms]   [k] sched_clock_cpu
     0.00%            30  a.out    [kernel.kallsyms]   [k] clockevents_program_event
     0.00%            30  a.out    [kernel.kallsyms]   [k] irq_exit
     0.00%            27  a.out    [kernel.kallsyms]   [k] cpu_needs_another_gp
     0.00%            32  a.out    libgomp.so.1.0.0    [.] 0x0000000000018b13
     0.00%            26  a.out    [kernel.kallsyms]   [k] run_posix_cpu_timers
     0.00%            24  a.out    [kernel.kallsyms]   [k] smp_apic_timer_interrupt
     0.00%            24  a.out    [kernel.kallsyms]   [k] rcu_irq_enter
     0.00%            23  a.out    a.out               [.] GOMP_critical_start@plt
     0.00%            22  a.out    [kernel.kallsyms]   [k] account_entity_dequeue
     0.00%            22  a.out    [kernel.kallsyms]   [k] native_read_msr_safe
     0.00%            21  a.out    [kernel.kallsyms]   [k] account_user_time
     0.00%            21  a.out    [kernel.kallsyms]   [k] irq_enter
     0.00%            20  a.out    [kernel.kallsyms]   [k] do_softirq
     0.00%            20  a.out    [kernel.kallsyms]   [k] local_apic_timer_interrupt
     0.00%            20  a.out    libgomp.so.1.0.0    [.] 0x000000000001850a
     0.00%            20  a.out    [kernel.kallsyms]   [k] _raw_qspin_lock_irq
     0.00%            19  a.out    [kernel.kallsyms]   [k] __remove_hrtimer
     0.00%            19  a.out    [kernel.kallsyms]   [k] task_tick_numa
     0.00%            19  a.out    libgomp.so.1.0.0    [.] 0x0000000000018414
     0.00%            19  a.out    [kernel.kallsyms]   [k] account_entity_enqueue
     0.00%            18  a.out    [kernel.kallsyms]   [k] rcu_irq_exit
     0.00%            18  a.out    [kernel.kallsyms]   [k] update_rq_clock.part.75
     0.00%            18  a.out    [kernel.kallsyms]   [k] __acct_update_integrals
     0.00%            17  a.out    [kernel.kallsyms]   [k] native_apic_msr_eoi_write
     0.00%            17  a.out    [kernel.kallsyms]   [k] rb_erase
     0.00%            17  a.out    [kernel.kallsyms]   [k] timerqueue_add
     0.00%           135  a.out    [kernel.kallsyms]   [k] native_sched_clock
     0.00%            20  a.out    [kernel.kallsyms]   [k] native_queued_spin_lock_slowpath
     0.00%            19  a.out    [kernel.kallsyms]   [k] x86_pmu_disable
     0.00%            14  a.out    libgomp.so.1.0.0    [.] 0x000000000001851f
     0.00%            14  a.out    [kernel.kallsyms]   [k] fetch_task_cputime
     0.00%            14  a.out    [kernel.kallsyms]   [k] task_cputime
     0.00%            12  a.out    [kernel.kallsyms]   [k] update_process_times
     0.00%            11  a.out    [kernel.kallsyms]   [k] raise_softirq
     0.00%            11  a.out    [kernel.kallsyms]   [k] call_softirq
     0.00%            11  a.out    [kernel.kallsyms]   [k] enqueue_hrtimer
     0.00%            10  a.out    [kernel.kallsyms]   [k] __hrtimer_get_next_event
     0.00%            10  a.out    [kernel.kallsyms]   [k] intel_pmu_disable_all
     0.00%            10  a.out    [kernel.kallsyms]   [k] tick_program_event
     0.00%             9  a.out    [kernel.kallsyms]   [k] __local_bh_enable
     0.00%             9  a.out    [kernel.kallsyms]   [k] hrtimer_forward
     0.00%             8  a.out    [kernel.kallsyms]   [k] nmi
     0.00%             8  a.out    libgomp.so.1.0.0    [.] 0x00000000000183e1
     0.00%             8  a.out    [kernel.kallsyms]   [k] profile_tick
     0.00%             8  a.out    [kernel.kallsyms]   [k] idle_cpu
     0.00%             6  a.out    [kernel.kallsyms]   [k] tick_sched_handle
     0.00%             6  a.out    [kernel.kallsyms]   [k] perf_pmu_disable
     0.00%             6  a.out    [kernel.kallsyms]   [k] account_process_tick
     0.00%             6  a.out    libgomp.so.1.0.0    [.] 0x0000000000018412
     0.00%             6  a.out    [kernel.kallsyms]   [k] irq_work_run_list
     0.00%             6  a.out    [kernel.kallsyms]   [k] msecs_to_jiffies
     0.00%             6  a.out    [kernel.kallsyms]   [k] rb_next
     0.00%             8  a.out    [kernel.kallsyms]   [k] x86_pmu_enable
     0.00%             6  a.out    [kernel.kallsyms]   [k] __intel_pmu_disable_all
     0.00%             7  a.out    [kernel.kallsyms]   [k] intel_pmu_enable_all
     0.00%             5  a.out    [kernel.kallsyms]   [k] tick_sched_do_timer
     0.00%             5  a.out    libgomp.so.1.0.0    [.] 0x00000000000183e2
     0.00%             5  a.out    [kernel.kallsyms]   [k] __x86_indirect_thunk_r14
     0.00%             5  a.out    [kernel.kallsyms]   [k] irq_work_tick
     0.00%             5  a.out    [kernel.kallsyms]   [k] timerqueue_del
     0.00%             5  a.out    libgomp.so.1.0.0    [.] 0x0000000000018509
     0.00%             5  a.out    libgomp.so.1.0.0    [.] 0x00000000000183f2
     0.00%            89  a.out    [kernel.kallsyms]   [k] _paravirt_nop
     0.00%             5  a.out    libgomp.so.1.0.0    [.] 0x0000000000018b1c
     0.00%            18  a.out    [kernel.kallsyms]   [k] __intel_pmu_enable_all.isra.23
     0.00%             4  a.out    [kernel.kallsyms]   [k] find_busiest_group
     0.00%             4  a.out    [kernel.kallsyms]   [k] hrtimer_run_queues
     0.00%             4  a.out    libgomp.so.1.0.0    [.] 0x00000000000183e0
     0.00%            66  a.out    [kernel.kallsyms]   [k] perf_pmu_sched_task
     0.00%            29  a.out    [kernel.kallsyms]   [k] sched_clock
     0.00%             4  a.out    [kernel.kallsyms]   [k] perf_pmu_enable
     0.00%             3  a.out    [kernel.kallsyms]   [k] update_blocked_averages
     0.00%             3  a.out    [kernel.kallsyms]   [k] retint_check
     0.00%             3  a.out    [kernel.kallsyms]   [k] smp_call_function_many
     0.00%             3  a.out    [kernel.kallsyms]   [k] llist_add_batch
     0.00%             3  a.out    [kernel.kallsyms]   [k] ret_from_intr
     0.00%             2  a.out    [kernel.kallsyms]   [k] acct_account_cputime
     0.00%             2  a.out    [kernel.kallsyms]   [k] call_function_interrupt
     0.00%             2  a.out    [kernel.kallsyms]   [k] find_next_bit
     0.00%             2  a.out    [kernel.kallsyms]   [k] __anon_vma_interval_tree_subtree_search
     0.00%             2  a.out    [kernel.kallsyms]   [k] rb_insert_color
     0.00%             2  a.out    [kernel.kallsyms]   [k] load_balance
     0.00%             2  a.out    [kernel.kallsyms]   [k] ioread32
     0.00%             2  a.out    [kernel.kallsyms]   [k] rcu_process_gp_end
     0.00%             2  a.out    [kernel.kallsyms]   [k] __list_del_entry
     0.00%             2  a.out    [kernel.kallsyms]   [k] perf_iterate_ctx
     0.00%             2  a.out    [kernel.kallsyms]   [k] x86_pmu_hw_config
     0.00%             2  a.out    [kernel.kallsyms]   [k] __memset
     0.00%            14  a.out    [kernel.kallsyms]   [k] finish_task_switch
     0.00%             1  a.out    [kernel.kallsyms]   [k] nohz_balance_exit_idle.part.59
     0.00%             2  a.out    [kernel.kallsyms]   [k] rebalance_domains
     0.00%             5  a.out    [kernel.kallsyms]   [k] ghes_read_estatus
     0.00%             1  a.out    libgomp.so.1.0.0    [.] 0x0000000000016411
     0.00%             1  a.out    [kernel.kallsyms]   [k] task_ctx_sched_out
     0.00%             1  a.out    [kernel.kallsyms]   [k] change_pte_range
     0.00%             1  a.out    [kernel.kallsyms]   [k] __x2apic_send_IPI_mask
     0.00%             1  a.out    [kernel.kallsyms]   [k] _raw_spin_unlock_irqrestore
     0.00%             1  a.out    [kernel.kallsyms]   [k] scheduler_ipi
     0.00%             1  a.out    [kernel.kallsyms]   [k] retint_swapgs
     0.00%             1  a.out    [kernel.kallsyms]   [k] enqueue_entity
     0.00%             1  a.out    [kernel.kallsyms]   [k] group_balance_cpu
     0.00%             1  a.out    [kernel.kallsyms]   [k] __perf_event_task_sched_out
     0.00%             1  a.out    [kernel.kallsyms]   [k] effective_load.isra.38
     0.00%             1  a.out    [kernel.kallsyms]   [k] _raw_spin_trylock
     0.00%             1  a.out    [kernel.kallsyms]   [k] rcu_report_qs_rnp
     0.00%             1  a.out    [kernel.kallsyms]   [k] rcu_process_callbacks
     0.00%             1  a.out    [kernel.kallsyms]   [k] exit_intr
     0.00%             1  a.out    [kernel.kallsyms]   [k] flush_smp_call_function_queue
     0.00%             1  a.out    [kernel.kallsyms]   [k] cpumask_next_and
     0.00%             1  a.out    [kernel.kallsyms]   [k] sched_clock_tick
     0.00%             1  a.out    [kernel.kallsyms]   [k] handle_mm_fault
     0.00%             1  a.out    libgomp.so.1.0.0    [.] 0x00000000000183e6
     0.00%             1  a.out    [kernel.kallsyms]   [k] check_for_new_grace_period.isra.26
     0.00%             1  a.out    [kernel.kallsyms]   [k] exit_idle
     0.00%             3  a.out    [kernel.kallsyms]   [k] system_call_after_swapgs
     0.00%             1  a.out    [kernel.kallsyms]   [k] intel_pebs_constraints
     0.00%             1  a.out    [kernel.kallsyms]   [k] __intel_shared_reg_get_constraints.isra.24
     0.00%             1  a.out    [kernel.kallsyms]   [k] __mutex_init
     0.00%             1  a.out    ld-2.17.so          [.] _start
     0.00%             1  a.out    [kernel.kallsyms]   [k] unmapped_area_topdown
     0.00%             1  a.out    [kernel.kallsyms]   [k] x86_pmu_max_precise
     0.00%             1  a.out    [kernel.kallsyms]   [k] _cond_resched
     0.00%             1  a.out    [kernel.kallsyms]   [k] perf_event_alloc
     0.00%             1  a.out    [kernel.kallsyms]   [k] __slab_free
     0.00%            26  a.out    [kernel.kallsyms]   [k] vunmap_page_range
     0.00%             1  a.out    [kernel.kallsyms]   [k] kmem_cache_alloc_node_trace
     0.00%            44  a.out    [kernel.kallsyms]   [k] ioremap_page_range
     0.00%             1  a.out    libc-2.17.so        [.] __getrlimit
     0.00%             1  a.out    ld-2.17.so          [.] do_lookup_x
     0.00%             9  a.out    [kernel.kallsyms]   [k] __perf_event_task_sched_in
     0.00%             1  a.out    [kernel.kallsyms]   [k] mm_update_next_owner
     0.00%            30  a.out    [kernel.kallsyms]   [k] ghes_notify_nmi
     0.00%            24  a.out    [kernel.kallsyms]   [k] nmi_restore
     0.00%            16  a.out    [kernel.kallsyms]   [k] end_repeat_nmi
     0.00%             1  a.out    [kernel.kallsyms]   [k] security_inode_permission
     0.00%             1  a.out    libgomp.so.1.0.0    [.] 0x00000000000162b0
     0.00%             3  a.out    [kernel.kallsyms]   [k] sysret_check
     0.00%             2  a.out    libpthread-2.17.so  [.] start_thread
     0.00%            19  a.out    [kernel.kallsyms]   [k] acpi_map_lookup
     0.00%             2  a.out    [kernel.kallsyms]   [k] kfree
     0.00%             2  a.out    libc-2.17.so        [.] __clone
     0.00%             8  a.out    [kernel.kallsyms]   [k] ghes_copy_tofrom_phys
     0.00%             1  a.out    libgomp.so.1.0.0    [.] 0x00000000000162c1
     0.00%             2  a.out    [kernel.kallsyms]   [k] perf_ctx_unlock
     0.00%             1  a.out    libgomp.so.1.0.0    [.] 0x0000000000018bbb
     0.00%             1  a.out    [kernel.kallsyms]   [k] system_call_fastpath
     0.00%            23  a.out    [kernel.kallsyms]   [k] intel_pmu_handle_irq
     0.00%             1  a.out    libgomp.so.1.0.0    [.] 0x0000000000018b3d
     0.00%             4  a.out    [kernel.kallsyms]   [k] native_flush_tlb_single
     0.00%            13  a.out    [kernel.kallsyms]   [k] arch_trigger_all_cpu_backtrace_handler
     0.00%            24  a.out    [kernel.kallsyms]   [k] nmi_handle.isra.0
     0.00%             4  a.out    [kernel.kallsyms]   [k] do_nmi
     0.00%             1  a.out    [kernel.kallsyms]   [k] __do_page_fault
     0.00%             2  a.out    [kernel.kallsyms]   [k] sysret_careful
     0.00%             1  a.out    [kernel.kallsyms]   [k] schedule_tail
     0.00%             1  a.out    [kernel.kallsyms]   [k] __audit_syscall_exit
     0.00%             1  a.out    [kernel.kallsyms]   [k] path_put
     0.00%             1  a.out    [kernel.kallsyms]   [k] futex_wait
     0.00%             1  a.out    [kernel.kallsyms]   [k] futex_wait_queue_me
     0.00%             1  perf     [kernel.kallsyms]   [k] perf_event_addr_filters_exec
     0.00%             1  a.out    [kernel.kallsyms]   [k] __schedule
     0.00%             4  a.out    [kernel.kallsyms]   [k] pud_clear_huge
     0.00%            20  a.out    [kernel.kallsyms]   [k] perf_sample_event_took
     0.00%             3  a.out    [kernel.kallsyms]   [k] __memcpy
     0.00%             4  a.out    [kernel.kallsyms]   [k] acpi_os_read_memory
     0.00%             4  a.out    [kernel.kallsyms]   [k] apei_read
     0.00%            14  a.out    [kernel.kallsyms]   [k] __kprobes_text_start
     0.00%             4  a.out    [kernel.kallsyms]   [k] apei_check_gar
     0.00%            18  a.out    [kernel.kallsyms]   [k] intel_bts_enable_local
     0.00%             2  a.out    [kernel.kallsyms]   [k] unmap_kernel_range_noflush
     0.00%             1  perf     [kernel.kallsyms]   [k] _paravirt_nop
     0.00%             1  perf     [kernel.kallsyms]   [k] native_sched_clock
     0.00%             5  perf     [kernel.kallsyms]   [k] native_write_msr_safe


#
# (Tip: See assembly instructions with percentage: perf annotate <symbol>)
#
```

O overhead vai aumentar com o aumento do número de iterações. O overhead total do critical é $2.10 \% + 1.58 \% = 3.68 \%  \text{ do tempo total }( 3.68 \% \cdot 4120 ms \approx 152 ms$).


---

### **2.** Develop an OpenMP code to implement the parallel execution of the QuickSort

#### **a)** Run the original code (`sbatch --partition=cpar run.sh`) and explain why one of runs takes longer to execute. 

Quando o Quicksort é aplicado a um array já ordenado (na segunda run é dado o mesmo pointer, por isso o array `a` já está ordenado) a complexidade é $O(N)$ (e não $O(Nlog_2N)$) 


#### **b)** Analyse the algorithm and suggest one parallel implementation based on `omp task`.

```c
void quickSort(float* arr, int size) 
{

        int i = 0, j = size;
        /* PARTITION PART */
        partition(arr, &i, &j);

    #pragma omp parallel
    {
        #pragma omp single
        if (0 < j){ 
                #pragma omp task
                quickSort_internel(arr, 0, j);
        }
        #pragma omp single
        if (i< size){
                #pragma omp task
                quickSort_internel(arr, i, size);
        }
    }
}
```

#### **c)** Analyse  the  algorithm  complexity  of  the  sequential  and  parallel  fractions,  knowing  that  the  average algorithm complexity of this sorting is $N\cdot\log_2(N)$. Estimate the maximum parallelization gain for the problem size of 2048, with 2 tasks. 

#### **d)** Run the code with 2, 4 and 8 threads, measure the scalability and explain the results. Run the program with `sbath --partition=cpar run2.sh`. Use perf to obtain the execution profile (remove `-fopenmp`  from the compilation and run the program with `sbath --partition=cpar perf2.sh` ).

#### **e)** Tuning: modify the parallelization approach to create tasks by the recursive call. Execute the program with 1, 2 and 4 threads and explain the results. 

#### **f)** Tuning:  remove  task  creation  when  the  size  of  the  sub-problem  is  less  or  equal  to  100  (parallelism cut-off). Execute the program with 1, 2 and 4 threads and explain the results. What is the best parallelism cut-off on this server?  


