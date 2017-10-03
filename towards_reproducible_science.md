class: middle, center

# Towards ~~Reproducible~~ Repeatable Science

Willi Rath (wrath@geomar.de)

.medium[**Thanks:** *Martin Claus, Christina Roth, Carsten Schirnick, Claas
Faber, Kai Grunau, Klaus Getzlaff, Torge Martin*]

---

class: top, left

## Two parts

--

### Part One -- A (Repeatable?) Example

*As a dummy project, we'll look at the seasonal cycle of
sea-surface height (SSH).  We'll see that there is a phase shift of 1/2 year
between the northern and the southern hemisphere.*

### Part Two -- Repeatable Workflows at Geomar

*We'll see which building blocks for a repeatable scientific
work flow are available at Geomar.*

---

class: middle, left

## Challenge

Those of you who have an idea what this plot shows, please do
now **take a note** (in pseudo-code or code) on how you would produce the
following figure.  Please be specific about when and how you select
regions, calculate averages, and modify the data otherwise.

---

## Part one:  Two simple time series

<img src="images/fig_01_tropical_ssh_index.png" width="700">

**Figure 01.** *Standardized mean SSH for the northern (blue) and southern
(green) tropics.*

---

class: middle

## Repeatability

Let's say an analysis is **repeatable**, if for any sufficiently skilled reader
it is **in principle** possible to **completely understand** and **repeat all
steps** the authors took from their initial idea to the final conclusions.

---

class: middle

## "completely understand and reapeat all steps"

1. Which **input data** were used?

2. **How** was the data treated to produce all figures and numbers given in the
   paper?

3. **Why** did the authors do what they did? ((Bonus) For any non-obvious
   choice of treatment of the data:)

---

class: middle, center

## Back to our figure

---

class: left, middle

<img src="images/fig_01_tropical_ssh_index.png" width="95%">

**Figure 01.**  Standardized mean SSH for the northern (blue) and southern
(green) tropics.

---

## The sloppy way

**Figure 01.**  Standardized mean SSH for the northern (blue) and southern
(green) tropics.

--

--------

This quite obviously is **problematic**:

- Which **data set** and which **variables** from the data set were used?

- Which **locations / times / regions** were included / excluded?

- What's the definition of **standardized**?

---

## Better

**Figure 1.** The blue / green line show standardized (`mean=0`, `std-dev=1`)
mean SSH for the northern / southern Tropics.  The lines represent spatial
averages of daily absolute dynamic topography from SLTAC between the Equator
and 23.43699°N / 23.43699°S and the Equator.

--

--------

We now know that

- daily **SLTAC** **ADT** fields were used,

- the data were **spatially averaged**,

- the standardized data has **`mean=0`** and **`std-dev=1`**,

- northern / southern Tropics are defined as the regions between 0 and
  **23.43699°N / 23.43699°S** and 0.

---

## Better

**Figure 1.** The blue / green line show **standardized** (`mean=0`, `std-dev=1`)
mean SSH for the northern / southern Tropics.  The lines represent **spatial
averages** of **daily absolute dynamic topography** from **SLTAC** between the Equator
and **23.43699°N** / **23.43699°S** and the Equator.

--------

But **still**:

- Could we be sure to find **exactly** the same data?

- How did the authors **weight** each grid point?

- How exactly and **at what point** did the authors **standardize** the data?

- Did they include **missing data**?  (And does it make a difference?)

- …

---

class: middle

## Towards full repeatability

**Figure 1.** The blue / green line show **standardized** (`mean=0`, `std-dev=1`)
mean SSH for the northern / southern tropics.  The lines represent spatial
averages of **daily absolute dynamic topography** from **SLTAC** between the Equator
and **23.43699°N** / **23.43699°S** and the Equator.  A script containing the full
code to produce the figure and a data file containing the time series data
that are plotted here are included in the **supplementary materials**.

---

class: middle

## The (essential parts of the) supplementary script

This is where you should have a look at your notes and compare.

---

#### The main part

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

ssh_index_north = standardize_time_series(
    spatial_average_between_latitudes(ssh, lat_min=0.0, lat_max=23.43699,
                                      new_name="SSH index North"))
ssh_index_south = standardize_time_series(
    spatial_average_between_latitudes(ssh, lat_min=-23.43699, lat_max=0.0,
                                      new_name="SSH index South"))

ssh_index_north.plot(); ssh_index_south.plot();
```

---

class: middle

## Saving data for reference

```python
output_dataset = xr.Dataset({'ssh_index_north': ssh_index_north,
                             'ssh_index_south': ssh_index_south})

output_dataset.to_netcdf("fig_01_tropical_ssh_index.nc")
```

---

## Data provenance

We use a data set from a [fully version-controlled data repository](https://git.geomar.de/data/SLTAC_GLO_PHY_L4_REP/):

```python
base_data_path = Path("/data/c2/TMdata/git_geomar_de_data/")
data_files = [str(fn) for fn in base_data_path.glob(
    "SLTAC_GLO_PHY_L4_REP/v1.x.x/data/2016/dt*nc")]
```

--

--------

Moreover, the following tells us that we're using `v1.1.0` of the
`SLTAC_GLO_PHY_L4_REP` data set:
```bash
git --work-tree="/data/c2/TMdata/git_geomar_de_data/SLTAC_GLO_PHY_L4_REP/v1.x.x/" describe
```
```
/data/c2/TMdata/git_geomar_de_data/SLTAC_GLO_PHY_L4_REP/v1.x.x
v1.1.0
```

--

--------

To learn more about the data set, check:

- <https://git.geomar.de/data/SLTAC_GLO_PHY_L4_REP/commits/v1.1.0> for a complete history of the our mirror of the data set,
- <https://git.geomar.de/data/SLTAC_GLO_PHY_L4_REP> for a general overview, a README of the current version, etc.

---

## Tools that were used

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

---

## Evolution of the analysis

To tell how this analysis developed in time, check:

<https://git.geomar.de/willi-rath/towards_reproducible_science/commits/master>

--

--------

This is a **time line** of every step towards the current version of this talk,
and the dummy analysis presented here.  Suppose, we developed the analysis as
part of a multi-author paper.  Then, it would be possible to return to any
specific version of the scripts at any later point, compare scripts between
revisions sent to the journal, or roll back any changes that are perhaps later
found to be wrong.

---

## Summary of part one

Essential bits of repeatable science are

1. a pointer to the full **raw data** used in the analysis (**data
   provenance**),

2. a **time-line** of the development of the analysis,

3. an overview of all the **tools** and **libraries** used in the analysis and
   of their exact versions,

4. fully **documented steps** from the original data to the final presentation
   (plots, tables, etc.),

5. a small and easy-to-use data set containing **all the numbers** necessary to
   re-plot and compare the data presented in the analysis.

---

class: middle, center

## Part two: Infrastructure at Geomar

---

## Part two: Infrastructure at Geomar

Currently, journals are requiring authors to provide some or even all of the
above.  (Today, you mostly get away with 5 and / or 4.  But expect to see
requirements including all of the above.)

Here, we'll look through the requirements 5. to 1. and examine to what extent, there are
(easy?) ways to fulfill them.

---

class: middle

## "All The Numbers" (5.)

1. **raw data** and **data provenance**

2. **time-line**

3. **tools** and **libraries**

4. **documented steps**

5. **all the numbers**

---

## "All The Numbers" (5.) ← <https://data.geomar.de>

--

- meant to serve as a **stable** point of **first contact** for anybody looking
  for a dataset from Geomar

  .medium[If a journal requires you to provide a reference to the data, this
  might be the information to give.  (Talk to <datamanagement@geomar.de> before
  doing so.)]

- today: **collection of links** to data for papers etc.

--

--------

Some alternatives:

- At TM, we have <data-tm@geomar.de> which will be forwarded to whoever will be
  in charge of data management.

- https://zenodo.org provides storage and a DOI for data.

--

--------

*Note that the **hard part** is not providing a point of contact for those
requesting the data.  The hard part is **being able to provide the data** at
any given time.*

---

class: middle

## "Documented steps" (4.)

1. **raw data** and **data provenance**

2. **time-line**

3. **tools** and **libraries**

4. **documented steps**

5. **all the numbers** ← <https://data.geomar.de>

---

## "Documented steps" (4.) ← <https://nb.geomar.de>

- Jupyter **frontend** to virtually all the **large machines** (in-house and
  external)

- **beautifully rendered** analyses

- automatic **documentation** is (almost) **for free**

- bonus:  The Geomar **Git** server renders Jupyter notebooks!

--

--------

It is definitely possible (and currently done) to do *all* analyses in your PhD
project with Jupyter and on <https://nb.geomar.de>.

---

class: middle

## "Tools and Libraries" (3.)

1. **raw data** and **data provenance**

2. **time-line**

3. **tools** and **libraries**

4. **documented steps** ← <https://nb.geomar.de>

5. **all the numbers** ← <https://data.geomar.de>

---

## "Tools and Libraries" (3.) ← [Conda environments](https://git.geomar.de/python/conda_environments/)

- use Anaconda (**Python** and **R**) and Conda-Forge (far beyond)

- explicitly **manage** and **document** full working **environments**

- across **different machines**

- standard environments

  - <https://git.geomar.de/python/conda_environments/>

  - on all the major analysis machines ← <https://nb.geomar.de>

---

class: middle

## "Time Line" (2.)

1. **raw data** and **data provenance**

2. **time-line**

3. **tools** and **libraries** ← <https://git.geomar.de/python/conda_environments/>

4. **documented steps** ← <https://nb.geomar.de>

5. **all the numbers** ← <https://data.geomar.de>

---

## "Time Line" (2.) ← <http://git.geomar.de>

- **full-blown** version control environment

- for **Geomar members** and for **external collaborators**.

- hosted at Geomar

- continuous integration

- unlimited projects

- project management

- …

---

class: middle

## "Data Provenance" (1.)

1. **raw data** and **data provenance**

2. **time-line** ← <https://git.geomar.de>

3. **tools** and **libraries** ← <https://git.geomar.de/python/conda_environments/>

4. **documented steps** ← <https://nb.geomar.de>

5. **all the numbers** ← <https://data.geomar.de>

---

## "Data" (1.) ← <https://git.geomar.de/data/>

- version control own and external data with Git LFS

- available at <https://git.geomar.de>

- tracking Terabytes (or more) of model output is beyond reach for now

--

--------

<https://git.geomar.de/data/docs/>

- Growing collection of external data sets.

- [Also available on the thredds
  server](https://data.geomar.de/thredds/catalog/tmdata/git_geomar_de_data/catalog.html)

--

--------

Transparently store large model data sets:

- clear hierarchical directory structure

- "single source of truth"

---

class: middle

## Summary

1. **raw data** and **data provenance** ← <https://git.geomar.de/data/>

2. **time-line** ← <https://git.geomar.de>

3. **tools** and **libraries** ← <https://git.geomar.de/python/conda_environments/>

4. **documented steps** ← <https://nb.geomar.de>

5. **all the numbers** ← <https://data.geomar.de>

---

## The (in my opinion) best part?

- only weak links between components

    - "plumbing" relies on standard sysadmin skills

    - ⇒ limited effects of failure / unavailability

- profit only from what you need

- remain fully independent from all other components

--

--------

For example, if you leave Geomar (or just go to sea for a month or three), it
is very easy to take all your projects from <https://git.geomar.de>, all your
data, all your notebooks, setup scripts for a conda environments identical to
those available at Geomar, ...

---

## Who needs this?


**Public Debate:**

- **fraud** prevention

- **facilitating** communication **within the community**

But the first and foremost beneficiary of your repeatable work flow are **you**.

----

**Your boss:** *"Can you update the plot from our 2012 paper with the latest data?"*

----

**You:** *Can you check that against satellite data?"*

**Student:** (all set up for two weeks of googling satellite data sets) *"Sure..."*

**You:** *[Here's a
script](https://git.geomar.de/edu/python-intro/blob/master/Session_04/Session_04_02_xarray.ipynb)
where I did a similar thing with the [old AVISO
data](https://git.geomar.de/data/AVISO). Maybe it's good to start there.
When you're familiar with this one, adapt it to the new [SLTAC
product](https://git.geomar.de/data/SLTAC_GLO_PHY_L4_REP).*

**Student:** (realizes they'll be able to start right away)

---

## What to do now?

- Skim [Sandve (2013)][Sandve2013] for the "Then Repeatability Commandments".
- Read the [reference sheet of Wilson (2012)][Wilson2012] to be prepared for
  coding.

- Have a mental framework for repeatability. **← This talk ...**

- Learn to use Git or any other version-control system.

- Keep track of your data.

- Script all your analyses.  Avoid (undocumented) interactive work whenever
  possible.

- Have a standard of numbering your versions.  (Always forward.  There
  should be no files called `.txt.old`!)

---

## Caveats and Todos

**Culture:**  Be(come more) confident to **publish** your **code and data**.

**Culture (cont.):**  Establish **ethics** with respect to use of code and data
published by others.

**Best practices:**

- **How much** to document?

- And **where**?

---

class: middle, center

# Thanks!

[Barnes2010]: https://www.nature.com/news/2010/101013/full/467753a.html

[Bhadrwaj2014]: https://arxiv.org/abs/1409.0798

[Chavan2015]: https://arxiv.org/abs/1506.04815

[Easterbrook2014]: http://www.nature.com/ngeo/journal/v7/n11/full/ngeo2283.html

[Hinsen2015]: https://khinsen.wordpress.com/2015/01/07/why-bitwise-reproducibility-matters/

[Hinsen2017]: http://blog.khinsen.net/posts/2017/05/04/which-mistakes-do-we-actually-make-in-scientific-code/

[Irving_carpentry]: http://damienirving.github.io/capstone-oceanography/03-data-provenance.html

[Irving2015]: http://journals.ametsoc.org/doi/full/10.1175/BAMS-D-15-00010.1

[Merali2010]: https://www.nature.com/doifinder/10.1038/467775a

[MIAME]: http://fged.org/projects/miame/

[MPI_good_scientific_practice]: http://www.mpimet.mpg.de/en/science/publications/good-scientific-practice.html

[Nature_CodeShare]: https://www.nature.com/news/code-share-1.16232

[Sandve2013]: http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1003285

[Stodden2010]: https://papers.ssrn.com/sol3/papers.cfm?abstract_id=1550193

[Wilson2012]: https://arxiv.org/abs/1210.0530

[XSEDE2014_repro]: https://www.xsede.org/documents/659353/d90df1cb-62b5-47c7-9936-2de11113a40f
