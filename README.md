# LagrangianParticleTracker
Here is a code which one can use in order to find the steady streaming velocities in the cochlea. 
Input your specific parameters, namely the number of files you want to process and the timstep between them. 
For the analysis, it is important to remember that the smoothing functions need a satisfactory amount of timesteps in order to find a trend. If the data set is too small, the smooth functions will not accurately map the centre point of the particle's sprial path, so bear this in mind! 
I would suggest to do some convergence testing on the time data, this can be done by adding more varaibles after part11 and part 12 and repeating the filtering for different time instances. A couple of checks and comparisions should show when the solution has converged. 

Any improvement to the filtering would be welcome, it is currently this step which is slow. The code is by no means yet optimised! 

