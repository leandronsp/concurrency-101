# Background jobs

## Simple
Simple uses one main process containing the interactive enqueuer and two worker Threads using local memory (queue).
```
ruby background-jobs/simple/main.rb
```

## Redis
The Redis version uses Redis as a queue (`RPUSH, BRPOP`), one process for the enqueuer and another process for the processor using two workers under forking.

Start the Redis backend:
```
make redis
```
Start the processor (2 worker forks):
```
ruby background-jobs/redis/processor.rb
```
Start the interactive enqueuer:
```
ruby background-jobs/redis/enqueuer.rb
```
In case you wish to unleash the madness and enqueue lots of jobs at once:
```
ruby background.jobs/redis/madness.rb
```
