[![Build Status](https://travis-ci.org/BCMSLab/aos.svg?branch=master)](https://travis-ci.org/BCMSLab/aos)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/BCMSLab/aos?branch=master&svg=true)](https://ci.appveyor.com/project/BCMSLab/aos)
# aos

Data, analysis scripts and output of the analysis of the aos; regulation of autophagy in response to oxidative stress

## Setting up the docker environment

The analysis was run on a [docker](https://cloud.docker.com/swarm/bcmslab/repository/docker/bcmslab/aos/general) image based on the the latest **bioconductor/release\_base2**. Other R packages were added to the image and were made available as an image that can be obtained and launched on any local machine running [docker](https://cloud.docker.com/swarm/bcmslab/repository/docker/bcmslab/aos/general).

```bash
$ docker pull bcmslab/aos
$ docker run -it bcmslab/aos bash
```

## Obtaining the source code

The source code is hosted publicly on this repository in a form of research compendium. This includes the functions used throughout the analysis as an R package, the scripts to run the analysis and finally the scripts to reproduce the figures and tables in this manuscript. From within the container, [git](https://git-scm.com) can be used to cloned the source code. The cloned repository contains a sub-folder called `analysis/scripts/` which can be used to reproduce the analysis from scratch

* `get_data.R` This scripts download several datasets from different sources in preparation of the analysis

* `analysis.R` This script loads the required libraries and runs all the steps of the analysis described in the manuscript

* `figures/` A sub-folder with a separate file for each graph in the manuscript.

* `tables/` A sub-folder with a sepearte file for each table in the manuscript.

The following code clones the repository containing the source code.

```bash
$ git clone http://github.com/BCMSLab/aos
```

## Running the analysis

The analysis scripts is organized to be ran using a single [make](https://www.gnu.org/software/make/) command. This will first load the necessary functions and run the main analysis and save the data in an R object `data/aos_wgcna.rda`. This will be used to generate the figures and graphs. In addition, a log file is generated in the sub-folder 'log/' for each script which can be used for troubleshooting.

To do that, the `make` command should be invoked from withing the `analysis/` sub-folder.

```bash
$ cd aos/analysis/
$ make
```

## Details of the R environment
The version of **R** that was used to perform this analysis is the 3.4.3 (2017-11-30) on `x86\_64-pc-linux-gnu`. The `DESCRIPTION` file in the main repository contains further details about the dependencies and the license of this work.

## More
