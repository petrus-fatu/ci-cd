import multiprocessing

# Use threaded workers;

worker_class = 'gthread'

# Number of workers in use;
workers = 2

# Use an arbitrary number of threads for concurrency;
threads = 10

# Store the process ID of gunicorn.  Used for testing;

pidfile = 'gunicorn_pid.txt'