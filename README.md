# DE Digital Filters - Digital Filters Solver
  * Research project on evolutionary hardware using [differential evolution](https://en.wikipedia.org/wiki/Differential_evolution), more specifically development of Infinite Impulse Response ([IIR](https://en.wikipedia.org/wiki/Infinite_impulse_response)) and Finite Impulse Response ([FIR](https://en.wikipedia.org/wiki/Finite_impulse_response)) Filters.

  * **Pontifical Catholic University of Paraná**

# Features
**Matlab:**
* [Classic DE](https://github.com/gbrunow/de-digital-filters/blob/master/MatlabDE/DE.m)
* [JADE](https://github.com/gbrunow/de-digital-filters/blob/master/MatlabDE/JADE.m)
* [SHADE](https://github.com/gbrunow/de-digital-filters/blob/master/MatlabDE/SHADE.m)
* [LSHADE](https://github.com/gbrunow/de-digital-filters/blob/master/MatlabDE/LSHADE.m)
* [LJADE](https://github.com/gbrunow/de-digital-filters/commit/104aa45644dafd9fcf49b6baac0bb835b0e49a8b)
* [Graphical User Interface](https://github.com/gbrunow/de-digital-filters/blob/master/MatlabDE/display.m)
![Matlab Graphical User Interface](https://raw.githubusercontent.com/gbrunow/de-digital-filters/master/assets/gui.png)

**R:**
* [JADE](https://github.com/gbrunow/de-digital-filters/blob/master/RDE/JADE.R)

# Benchmark Functions
* [Rosenbrock](https://en.wikipedia.org/wiki/Rosenbrock_function)<br/>
![Rosenbrock Benchmark Function](https://raw.githubusercontent.com/gbrunow/de-digital-filters/master/assets/rosenbrock.png)
* [Rastrigin](https://en.wikipedia.org/wiki/Rastrigin_function)<br/>
![Rastrigin Benchmark Function](https://raw.githubusercontent.com/gbrunow/de-digital-filters/master/assets/rastrigin.png)

# Instructions
* This solver can be utilized through the graphical interface – by running the [main.m](https://github.com/gbrunow/de-digital-filters/blob/master/MatlabDE/main.m) file – or directly running the functions for the desired optimizer (e.g. JADE, LSHADE, etc). 

# Help
* [MatlabDE/test.m](https://github.com/gbrunow/de-digital-filters/blob/master/MatlabDE/test.m) has examples of IIR design using differential evolution.
* [RDE/test.R](https://github.com/gbrunow/de-digital-filters/blob/master/RDE/test.R) has another example of IIR design.
