# Concurrency and Parallelism 101

## The beginning
- Early computers were capable of running only one program at a time
- Users loaded their programs into the compuer using punched paper cards or magnetic tape
- It took days or weeks to run programs
- Users wait on lines in order to run their programs. Long waits.

## Batch processing
- Computers got faster, then programs called "monitors" (later operating systems)
were created to execute programms (jobs) in batch
- Users no longer need to wait, they just send the job to the monitor which will
put the program in the queue to be processed later
- CPUs used to get in "idle" state while waiting the job to finish an IO operation

## Time-sharing multitasking
- In the 60's, the "Third-generation systems" could run multiple queued batch jobs at the same time
- The system are kept as busy as possible, while one program waits input/ouput, the other can use the CPU

## Operating systems and Processes
- As computers evolved, improved versions of "monitors" are now called "Operating Systems"
- Operating Systems started to improve multitasking capabilities
- Process: an instance of a computer program
- Processes use physical resources, like CPU, memory and IO
- A process is a task or job to be processed and has its own memory space

## Multitasking in operating systems
- Multitasking is the concurrent execution of multiple tasks (processes) over a certain period of time
- OS scheduler coordinates the tasks, interrupts, saving state and resume
- Preemptive: the scheduler pauses/resumes the task
- Cooperative: the task tells the scheduler when it can be paused/resumed
- As in the early days of multitasking, the resources are kept as busy as possible, which means
the CPU can process one task while another one is blocked by an IO operation
- Multitasking increases the rate of data being processed (throughput)
- As multitasking allows to improve the throughput, programmers started to implement applications
by spawning a set of cooperative processes: one for gathering input data, one for processing the data and one for
writing results to the output
- Process do not share memory to each other, so it's hard for programmers to efficiently exchange data
between processes

## Threads and multithreading
- Threads were created to use cooperative processes efficiently by sharing the same process memory space
- Are slices of programs, usually they are part of a process
- They are smaller and lightweight because there's no need to change the memory context
- Threads are scheduled preemptively
- Some OS's provide a variant to threads, called "Fibers", that are scheduled cooperatively
