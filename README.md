# Towards Reproducible Science

**Scenario:** *As a dummy project, we'll want to show global mean sea-level rise
based on satellite-altimetry data.*

**Reproducibility:** *Let's say a paper presents reproducible science if for any
reader it is in principle possible to completely understand all steps the
authors took from their initial data to the final conclusions.*

This often means, that the following questions can be answered
unanimously:

1. Which input data were used?

2. How was the data treated to produce all figures and numbers given in the
   paper?
3. For any non-obvious choice of treatment of the data: Why did the authors do
   what they did?

## How to do this

### The sloppy way

> Figure 1: The solid line shows global mean SSH calculated from annual-mean
> satellite-altimeter data.  The dashed line shows a trend of 2.9cm/decade.

This clearly is problematic:

- Which data set and which variables from the data set were used?
- Which data points / times / regions were included / excluded?
- Was there any processing?
- How was the trend estimated?

### A better way

> Figure 1: The solid line shows global-mean SSH calculated from annual-means of
> daily absolute dynamic topography fields provided by Copernicus (SLTAC L4).
> The dashed line shows a linear regression with slope 2.9cm/decade.  As the
> satellite-altimeter cannot determine sea-level under ice, all grid points that
> are covered by ice at least once in the period from 1993 till 2016 are not
> included in the global mean.

We now know that

- The Copernicus ADT fields were used.
- Annual-means were derived from daily data.
- The trend is from a linear regression.
- Ice-covered grid points were excluded.
- Data from 1993 to 2017 were included.

But still:

- Can we be sure to find **exactly** the same data?
- How did the authors treat leap-years?
- How exactly did the authors do the linear regression?

## Infrastructure at Geomar

### Version controlled source

#### Why?

Don't version-control backwards.  There always will be a next version.  So plan
accordingly right at the beginning.

### Self-documenting analysis

nb.geomar.de and Jupyter Notebooks provide a way of writing analyses where
documentation is (almost) for free.

### Version controlled (upstream) data

Git LFS at git.geomar.de provide a way to version control own data and virtually
all external / upstream data.

## Todo

Best practices:  How much to document?  And where?  (In a separate repository, supplementary materials, in the paper?)

Culture:  Be confident to publish your code add data.

Culture (cont.):  How to establish ethical / un-ethical use of code and data
published by others?
