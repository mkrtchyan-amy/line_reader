# README
### 1. How does your system work?

- ### Setup:
  Run `bash build.sh` to install dependencies, start `redis-server`, generate and index test file.
  
  To run the application run `bash run.sh`.

- ### API:
  The system uses Sinatra, a lightweight Ruby web framework, to serve requests. The main API endpoint (`/lines/:id`) accepts a line number as a parameter. When a user makes a request for a line (e.g., `/lines/1`), the system:
  1. Validates that the requested line number is within the range of lines in the file.
  2. Retrieves the byte offset for that line from Redis.
  3. Uses the offset to find the correct position in the file and read the corresponding line.
  
- ### Connection Pools:
  Connection pools are used for both Redis and file reading, helping reuse connections instead of creating new ones each time. This reduces delays and improves performance.

- ### Concurrency and Performance:
  Puma, a Ruby web server, is used to handle multiple incoming requests concurrently. The system is configured to use multiple workers (defined by the `WEB_CONCURRENCY` setting) and multiple threads (defined by the `WEB_THREADS` setting), so it can handle many requests at once.
  If the system needs to scale further (for example, when dealing with large files or many users), horizontal scaling (adding more application instances) and load balancing can be used.

- ### Error Handling:
  If an invalid line index is requested (either below 1 or above the total number of lines), the system responds with an error (HTTP status 413), informing the user that the requested line is beyond the available lines in the file.


This approach optimizes performance by:
- Using Redis to cache line offsets and frequently requested lines.
- Using connection pools for Redis and file reading to reuse connections instead of creating new ones each time.
- Avoiding loading the entire file into memory, making it more efficient for large files.
- Using Puma to handle multiple requests concurrently for better scalability.

### 2. How will your system perform with 100 users? 10,000 users? 1,000,000 users?
At this point the system’s performance depends on its configuration (Puma workers, threads, and the connection pools).
The system performs well with 100 users, handles 10,000 users with increased load, but may struggle with 1,000,000 users, requiring horizontal scaling and load balancing.

### 3. How will your system perform with a 1 GB file? A 10 GB file? A 100 GB file?
With Redis and file reader connection pools, the system handles large files efficiently, with performance remaining stable for files up to 10 GB, while files over 100 GB may require additional optimizations.

### 4. What documentation, websites, papers, etc did you consult in doing this assignment?
- https://pfoplabs.daraghbyrne.me/2-sinatra-basics/1-creating-a-basic-sinatra-project/
- https://www.oreilly.com/library/view/sinatra-up-and/9781449306847/ch04.html
- https://essenceofchaos.gitbooks.io/learn-ruby-first/content/section-three/reading-files.html
- https://onlyoneaman.medium.com/unlocking-the-power-of-redis-storing-any-object-as-cache-in-ruby-on-rails-518536e2182
- https://msp-greg.github.io/puma/
- https://github.com/mperham/connection_pool
- https://testing-for-beginners.rubymonstas.org/rack_test/sinatra.html
- https://shiroyasha.io/sinatra-app-with-rspec.html
- https://github.com/bkeepers/dotenv
- https://github.com/ruby/singleton

### 5. What third-party libraries or other tools does the system use? How did you choose each library or framework you used?
`Sinatra`: Sinatra is preferred for its simplicity, lightweight nature, and faster performance, without the complexity of Rails or Grape. Ideal for small to medium-sized applications where speed and resource efficiency are key.

`Puma`: Puma is used because it's a fast, concurrent web server that efficiently handles multiple requests.

`Redis`: Redis is used because it's fast and efficient for storing and retrieving data quickly.

`Connection Pool`: To reuse connections instead of creating new ones each time.

`Dotenv`: Allows for easy configuration of the system’s settings in a local development environment.

### 6. How long did you spend on this exercise? If you had unlimited more time to spend on this, how would you spend it and how would you prioritize each item?

I spent one day on research and 4 hours each day for 4 days to implement, test, and document the feature.

If I had unlimited time, I’d focus on:
- Code optimization
- Improving error handling
- Writing more tests, including stress tests to check the feature under heavy load.


The implementation efficiently covers the basics, particularly with the use of Puma, Redis and FileReader connection pools. To optimize further, I would start by testing the app under heavy load to see how many requests it can handle and how fast it responds. This would help me find the main performance problem.
Next, I would adjust settings like the connection pool size, number of threads, and workers to improve performance.

If the file is too big, I would split it into smaller parts (e.g., 1,000 lines per file) while keeping line offsets in Redis. This would make both indexing and reading lines faster.

I would also copy these smaller files to different servers and use a load balancer to share the workload and handle requests more efficiently.

If these optimizations are not enough, I would try using Redis Lua scripts and check if they improve performance.
