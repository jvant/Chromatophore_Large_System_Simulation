import multiprocessing

class multi_threading():
    
    results = []
    
    def __init__(self, inputs, num_processors, task_class_name):

        self.results = []

        # first, if num_processors <= 0, determine the number of processors to use programatically
        if num_processors <= 0: num_processors = multiprocessing.cpu_count()

        # reduce the number of processors if too many have been specified
        if len(inputs) < num_processors: num_processors = len(inputs)

        # now, divide the inputs into the appropriate number of processors
        inputs_divided = {}
        for t in range(num_processors): inputs_divided[t] = []

        for t in range(0, len(inputs), num_processors):
            for t2 in range(num_processors):
                index = t + t2
                if index < len(inputs): inputs_divided[t2].append(inputs[index])

        # now, run each division on its own processor

	running = multiprocessing.Value('i', num_processors)
	mutex = multiprocessing.Lock()

	arrays = []
	threads = []
	for i in range(num_processors):
	    threads.append(task_class_name())
	    arrays.append(multiprocessing.Array('i',[0, 1]))

	results_queue = multiprocessing.Queue() # to keep track of the results

	processes = []
	for i in range(num_processors):
	    p = multiprocessing.Process(target=threads[i].runit, args=(running, mutex, results_queue, inputs_divided[i]))
	    p.start()
	    #p.join()
	    processes.append(p)

	while running.value > 0: is_running = 0 # wait for everything to finish
	
	# compile all results
	for thread in threads:
	    chunk =  results_queue.get()
	    self.results.extend(chunk)

class general_task: # other, more specific classes with inherit this one
    
    results = []
    
    def runit(self, running, mutex, results_queue, items):
        for item in items: self.value_func(item, results_queue)
        mutex.acquire()
        running.value -= 1
        mutex.release()
        results_queue.put(self.results)

    def value_func(self, item, results_queue): # this is the function that changes through inheritance
        print item # here's where you do something
        self.results.append(item) # here save the results for later compilation

'''class add_a(general_task):
    
    def value_func(self, item, results_queue): # so overwriting this function
        self.results.append(str(item) + "MOOSE") # here save the results for later compilation
        #print self.results

some_input = range(1000)
tmp = multi_threading(some_input,10, add_a)
print tmp.results'''
