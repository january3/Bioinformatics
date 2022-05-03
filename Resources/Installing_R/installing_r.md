There are two options for you:

 1) Use R from Rstudio. This is the way I will be using it during lectures
 / practicals, because I am more familiar with it.

 2) Use R from Jupyter Notebook. That way is recommended by the university.


Installation instructions:

# Installing R with Rstudio

There are two parts to that. First you need to install R, and *then* you
need to install Rstudio. Please choose a recent version of R (> 4.0).

Here are the links which will guide you through the installation process:

 * [Installing R/Rstudio on MacOS](https://medium.com/@GalarnykMichael/install-r-and-rstudio-on-mac-e911606ce4f4) (however, please install a more recent version of R)
 * [Installing R/Rstudio on Windows 10](https://techdecodetutorials.com/data-science/how-to-download-r-and-install-rstudio-on-windows-10/)
 * Install R on Ubuntu / Linux: should be straightforward, just go to the
   software app and search for rstudio; this will install R automatically
   as well.
 * [Here is another link](https://www.datacamp.com/community/tutorials/installing-R-windows-mac-ubuntu) for the three OS


# Installing R for use with Jupyter Notebook

This assumes that you have Jupyter Notebook already installed. What you now
need is a so-called "kernel" – the part that actually runs R.

First, install R on your system (refer to the tutorials above on how to do
it). 

Then, open R and at its command line type the following:

```r
install.packages("IRkernel")
```

More detailed instructions can be found
[here](https://richpauloo.github.io/2018-05-16-Installing-the-R-kernel-in-Jupyter-Lab/)
and
[here](https://developers.refinitiv.com/en/article-catalog/article/setup-jupyter-notebook-r).




