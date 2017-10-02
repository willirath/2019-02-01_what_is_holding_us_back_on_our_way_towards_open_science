# Towards Reproducible Science

## Two parts

**Part one:** *As a dummy project, we'll look at the seasonal cycle of
sea-surface height (SSH).  We'll see that there is a phase shift of 1/2 year
between the northern and the southern hemisphere.*

**Part two:** *We'll see which building blocks for a reproducible scientific
work flow are available at Geomar.*

---

## Part one:  Two simple time series

**Challenge:** Those of you who have an idea what this plot shows, please do
now take a note (in pseudo-code or code) on how you would produce it.  Please
be specific about when and how you select regions, calculate averages, and
modify the data otherwise.

![Figure 01. Tropical SSH indices](images/fig_01_tropical_ssh_index.png)

**Figure 01.** *Standardized mean SSH for the northern (blue) and southern
(green) tropics.*

## Reproducibility

Let's say an analysis is reproducible, if for any sufficiently skilled reader it
is **in principle** possible to **completely understand** and **repeat all
steps** the authors took from their initial idea to the final conclusions.

This often means, that the following must be specified:

1. Which input data were used?

2. How was the data treated to produce all figures and numbers given in the
   paper?

3. (Bonus) For any non-obvious choice of treatment of the data:  Why did the
   authors do what they did?

## How to adequately describe our figure?

### The sloppy way (see above)

> *Figure 01.*  Standardized mean SSH for the northern (blue) and southern
> (green) tropics.

This quite obviously is problematic:

- Which data set and which variables from the data set were used?
- Which data points / times / regions were included / excluded?
- What's the definition of standardized?

### A better way

> *Figure 1.* The blue / green line show standardized (`mean=0`, `std-dev=1`)
> mean SSH for the northern / southern tropics.  The lines represent spatial
> averages of daily absolute dynamic topography from SLTAC between the Equator
> and 23.43699°N / 23.43699°S and the Equator.

We now know that

- daily SLTAC ADT fields were used,
- the data were spatially averaged,
- the standardized data has `mean=0` and `std-dev=1`,
- northern / southern tropics are defined as the regions between 0 and
  23.43699°N / 23.43699°S and 0.

But still:

- Could we be sure to find **exactly** the same data?
- How did the authors weight each grid point?
- How exactly and at what point did the authors standardize the data?
- Did they include missing data?  (And does it make a difference?)

### Towards full reproducibility

> *Figure 1.* The blue / green line show standardized (`mean=0`, `std-dev=1`)
> mean SSH for the northern / southern tropics.  The lines represent spatial
> averages of daily absolute dynamic topography from SLTAC between the Equator
> and 23.43699°N / 23.43699°S and the Equator.  A script containing the full
> code to produce the figure and a data file containing the time series data
> that are plotted here are included in the supplementary materials.

### The (essential parts of the) supplementary script

This is where you should have a look at your notes and compare.  (Note that
there's not necessarily a correct or best way to do this analysis.  But you
might notice that there are many ways that are fully compatible with a short
description of the figure.)

```python
from pathlib import Path
import xarray as xr

base_data_path = Path("/data/c2/TMdata/git_geomar_de_data/")
data_files = [str(fn) for fn in base_data_path.glob(
    "SLTAC_GLO_PHY_L4_REP/v1.x.x/data/2016/dt*nc")]

ssh = xr.open_mfdataset(data_files).adt

def standardize_time_series(data):
    """Return data with mean zero and std.-dev. one."""
    return (data - data.mean(dim="time")) / data.std(dim="time")

def spatial_average_between_latitudes(
    data, lat_min=-90.0, lat_max=90.0, new_name=None):
    """Return spatially averaged `data`.

    The data are not weighted and missing data are excluded.
    """
    data = data.sel(latitude=slice(lat_min, lat_max))
    data = data.mean(dim=["latitude", "longitude"])
    data = data.rename(new_name)
    return data

# first average (both, lat and lon, simultaneously), then standardize
ssh_index_north = standardize_time_series(
    spatial_average_between_latitudes(
        ssh, lat_min=0.0, lat_max=23.43699,
        new_name="SSH index North"))
ssh_index_south = standardize_time_series(
    spatial_average_between_latitudes(
        ssh, lat_min=-23.43699, lat_max=0.0,
        new_name="SSH index South"))

ssh_index_north.plot();
ssh_index_south.plot();
```

#### Saving data for reference

```bash
output_dataset = xr.Dataset({'ssh_index_north': ssh_index_north,
                             'ssh_index_south': ssh_index_south})
output_dataset.to_netcdf("fig_01_tropical_ssh_index.nc")
```

#### Data provenance

We use a data set from a [fully version-controlled data repository](https://git.geomar.de/data/SLTAC_GLO_PHY_L4_REP/):

```python
base_data_path = Path("/data/c2/TMdata/git_geomar_de_data/")
data_files = [str(fn) for fn in base_data_path.glob(
    "SLTAC_GLO_PHY_L4_REP/v1.x.x/data/2016/dt*nc")]
```

Moreover, the following tells us that we're using `v1.1.0` of the
`SLTAC_GLO_PHY_L4_REP` data set:
```bash
git --work-tree="/data/c2/TMdata/git_geomar_de_data/SLTAC_GLO_PHY_L4_REP/v1.x.x/" describe
```
```
/data/c2/TMdata/git_geomar_de_data/SLTAC_GLO_PHY_L4_REP/v1.x.x
v1.1.0
```

To learn more about the data set, check:

- <https://git.geomar.de/data/SLTAC_GLO_PHY_L4_REP/commits/v1.1.0> for a complete history of the our mirror of the data set,
- <https://git.geomar.de/data/SLTAC_GLO_PHY_L4_REP> for a general overview, a README of the current version, etc.

#### Tools that were used

The following lists the complete Python environment that was used in the
analysis:

```bash
conda list
```
```
# packages in environment at /home/wrath/TM/software/miniconda3_20170727/envs/py3_std:
#
alabaster                 0.7.10                   py35_1    conda-forge
anaconda-client           1.6.5                      py_0    conda-forge
aospy                     0.1.2                    py35_0    conda-forge
[...]
xarray                    0.9.6                    py35_0    conda-forge
xz                        5.2.3                         0    conda-forge
yaml                      0.1.6                         0    conda-forge
zeromq                    4.2.1                         1    conda-forge
zict                      0.1.3                      py_0    conda-forge
zlib                      1.2.8                         3    conda-forge
```

### Evolution of the analysis

To tell how this analysis developed in time, check:

<https://git.geomar.de/willi-rath/towards_reproducible_science/commits/master>

This is a time line of every step towards the current version of this talk, and
the dummy analysis presented here.  Suppose, we developed the analysis as part
of a multi-author paper.  Then, it would be possible to return to any specific
version of the scripts at any later point, compare scripts between revisions
sent to the journal, or roll back any changes that are perhaps later found to
be wrong.

---

## Summary of part one

Essential bits of reproducible science are:

1. a pointer to the full **raw data** used in the analysis (**data
   provenance**),
2. a **time-line** of the development of the analysis,
3. an overview of all the **tools** and **libraries** used in the analysis and
   of their exact versions,
4. fully **documented steps** from the original data to the final presentation
   (plots, tables, etc.),
5. a small and easy-to-use data set containing **all the numbers** necessary to
   re-plot and compare the data presented in the paper.

---

## Part two: Infrastructure at Geomar

Currently, journals are requiring authors to provide some or even all of the
above.  (Today, you mostly get away with 5 and / or 4.  But expect to see
requirements including all of the above.)

Here, we'll look through the requirements 5. to 1. and examine to what extent, there are
(easy?) ways to fulfill them.

### Provide the final numbers (5.)

#### https://data.geomar.de

There's <https://data.geomar.de> which is meant to serve as a stable point of
first contact for anybody looking for a dataset from Geomar.  If a journal
requires you to provide a reference to the data, this might be the information
to give.  (Talk to <datamanagement@geomar.de> before doing so.)

For now, <https://data.geomar.de> is a collection of links to data for papers
etc.  Expect development with respect to how the different data sets are
organized.

Alternatives:
- At TM, we have <data-tm@geomar.de> which will be forwarded to whoever will be
  in charge of data management.
- https://zenodo.org provides storage and a DOI for data.

(Note that the hard part is not providing a point of contact for those
requesting the data.  The hard part is being able to provide the data at any given
time.)

### Self-documenting analysis (4.)

Jupyter provides a way of writing analyses where (beautifully rendered)
automatic documentation is (almost) for free.

<https://nb.geomar.de> is a Jupyter frontend to virtually all the large
(in-house and external) machines.  It is definitely possible (and currently done!) to
perform all analyses for your PhD thesis with Jupyter.

A bonus (related to 2. below):  The Geomar Git server renders Jupyter notebooks.

### Easy reproduction of the exact environment used in the analysis (3.)

With Anaconda (Python and R) and Conda-Forge (far beyond), there's an easy way
to explicitly manage and document full working environments across different machines and through time.  There are standard
environments that are available on all the major analysis machines (and via
<https://nb.geomar.de>):

<https://git.geomar.de/python/conda_environments/>

### Keep a time line of all your steps (2.)

With <https://git.geomar.de>, there's a full-blown version control environment
for Geomar members and for external collaborators.

### Keep track of (large) data sets (1.)

Git LFS at <https://git.geomar.de> provides a way to version control own data
and virtually all external / upstream data.  For the moment, tracking Terabytes
(or more) of model output is beyond reach.  But there already is a growing
collection of regularly updated mirrors of external data sets:

<https://git.geomar.de/data/docs/>

To track large model data sets, at least have a transparent to store the data
(or) pointers to where the actual data are found.

---

## The (in my opinion) best part?

Even though all of the tools and services detailed above are interacting via
multiple links, none of these links are vital to the system or to your work.

This way, you can profit from any service that suits your needs and remain fully
independent from any of the others. For example, if you leave Geomar (or just go
to sea for a month or three), it is very easy to take all your projects from
<https://git.geomar.de>, all your data, all your notebooks, setup scripts for
a conda environments identical to those available at Geomar, ...

(Another benefit: Even if parts of the system become unavailable for some time or
forever, it is very unlikely to really impact any of your work.)

---

## Who needs this?

Note that even though the reproducibility debate circles around fraud
prevention and facilitating communication within the scientific community, the
first and foremost beneficiary of your reproducible work flow are you.  After
all, it is far more common for your boss to ask you if you could re-do the
"plot from our 2012 paper with more recent data" than for any collaborator to
try to reproduce (or question) any of your work.

The second biggest profit is for your current and future co-workers.  Imagine
being able to get a PhD student started without sending them on a multi-week
Google odysee before even being able to start and "check that against
satellite data".

## What to do now?

- [x] Have a mental framework for reproducibility.
- [ ] Learn to use Git or any other version-control system.
- [ ] Keep track of your data.
- [ ] Script all your analyses.  Avoid (undocumented) interactive work whenever
  possible.
- [ ] Have a standard of numbering your versions.  (Always forward.  There
should be no files called `.txt.old`!)

## Caveats and Todos

Best practices:  How much to document?  And where?  (In a separate repository,
supplementary materials, in the paper?)

Culture:  Be(come more) confident to publish your code add data.

Culture (cont.):  Establish ethics with respect to use of code and data
published by others.

## References

[Barnes2010]: https://www.nature.com/news/2010/101013/full/467753a.html

[Bhadrwaj2014]: https://arxiv.org/abs/1409.0798

[Chavan2015]: https://arxiv.org/abs/1506.04815

[Hinsen2015]: https://khinsen.wordpress.com/2015/01/07/why-bitwise-reproducibility-matters/

[Hinsen2017]: http://blog.khinsen.net/posts/2017/05/04/which-mistakes-do-we-actually-make-in-scientific-code/

[Irving_carpentry]: http://damienirving.github.io/capstone-oceanography/03-data-provenance.html

[Irving2015]: http://journals.ametsoc.org/doi/full/10.1175/BAMS-D-15-00010.1

[MIAME]: http://fged.org/projects/miame/

[MPI_good_scientific_practice]: http://www.mpimet.mpg.de/en/science/publications/good-scientific-practice.html

[Nature_CodeShare]: https://www.nature.com/news/code-share-1.16232

[Sandve2013]: http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1003285

[Stodden2010]: https://papers.ssrn.com/sol3/papers.cfm?abstract_id=1550193

[Wilson2012]: https://arxiv.org/abs/1210.0530

[XSEDE2014_repro]: https://www.xsede.org/documents/659353/d90df1cb-62b5-47c7-9936-2de11113a40f
