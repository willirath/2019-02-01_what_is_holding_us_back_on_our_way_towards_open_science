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

## References

[Hinsen2015]: https://khinsen.wordpress.com/2015/01/07/why-bitwise-reproducibility-matters/

[Hinsen2017]: http://blog.khinsen.net/posts/2017/05/04/which-mistakes-do-we-actually-make-in-scientific-code/

[MIAME]: http://fged.org/projects/miame/

[Wilson2012]: https://arxiv.org/abs/1210.0530

[Irving_carpentry]: http://damienirving.github.io/capstone-oceanography/03-data-provenance.html

[Nature_CodeShare]: https://www.nature.com/news/code-share-1.16232

[Sandve2013]: http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1003285

[Stodden2010]: https://papers.ssrn.com/sol3/papers.cfm?abstract_id=1550193

[MPI_good_scientific_practice]: http://www.mpimet.mpg.de/en/science/publications/good-scientific-practice.html

[Barnes2010]: https://www.nature.com/news/2010/101013/full/467753a.html

[Irving2015]: http://journals.ametsoc.org/doi/full/10.1175/BAMS-D-15-00010.1

[Chavan2015]: https://arxiv.org/abs/1506.04815
