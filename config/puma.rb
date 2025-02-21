require 'sinatra'

workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['WEB_THREADS'] || 5)
threads threads_count, threads_count

bind "tcp://0.0.0.0:4567"

preload_app!