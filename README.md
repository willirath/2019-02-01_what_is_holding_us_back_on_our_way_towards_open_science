# Towards Reproducible Science

**Scenario:** *As a dummy project, we'll look at the seasonal cycle of
sea-level in the year 2016.  We expect that there is a phase shift of 1/2
year between the northern and the southern hemisphere.*

**Reproducibility:** *Let's say a paper presents reproducible science if for
any reader it is in principle possible to completely understand and repeat all
steps the authors took from their initial idea to the final conclusions.*

This often means, that the following must be specified unambiguously:

1. Which input data were used?

2. How was the data treated to produce all figures and numbers given in the
   paper?

3. For any non-obvious choice of treatment of the data: Why did the authors do
   what they did?

## How to do this

### The sloppy way

> Figure 1: The blue / green lines show standardized mean ADT for the northern
> / southern tropics.

This clearly is problematic:

- Which data set and which variables from the data set were used?
- Which data points / times / regions were included / excluded?
- Was there any additional processing?

### A better way

> Figure 1: The blue / green line show standardized mean ADT for the northern /
> southern tropics.  The lines represent spatial averages of daily absolute
> dynamic topography from SLTAC between the Equator and 30N / 30S and the
> Equator.

We now know that

- The SLTAC ADT fields were used.
- The authors used daily data.
- The data were spatially averaged.
- Northern / southern tropics were defined as 0...30N, 30S...0.

But still:

- Can we be sure to find **exactly** the same data?
- How did the authors weight each grid point?
- How did they standardize the data (common scale / different scales for North
  / South, etc.)?

### Towards full reproducibility



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

[XSEDE2014_repro]: https://www.xsede.org/documents/659353/d90df1cb-62b5-47c7-9936-2de11113a40f
