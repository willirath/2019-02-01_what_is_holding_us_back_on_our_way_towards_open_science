class: middle, left

# ~~Reproducible~~ Repeatable Work Flows

Willi Rath (<wrath@geomar.de>)

.medium[**Thanks:** *Martin Claus, Claus Böning, Torge Martin, Markus
Scheinert, Klaus Getzlaff, Christina Roth, Geomar Data Management Team, Geomar
IT Department, ...*]

---

class: middle, left

## Part One — A (Repeatable?) Analysis

Example project: *global-mean sea-surface-temperature time series*

## Part Two — Repeatable Workflows at Geomar

*building blocks for a repeatable work flow at Geomar*

---

class: middle

## Repeatability

Let's say an analysis is **repeatable**, if for any sufficiently skilled reader
it is **in principle** possible to **completely understand** and **repeat all
steps** the author took from their initial idea to the final conclusions.

---

class: middle

## "completely understand and reapeat all steps"

1. Which **input data** were used?

2. **How** was the data treated to produce all **figures** and **numbers**
   given in the paper?

3. **Why** did the authors do what they did? ← *a bonus?*

---

class: middle, left

## Challenge

Those of you who have an idea what the following plot shows, please  **take a
note** (in pseudo-code or code) on how you would produce it.

Please be specific about **when** and **how** you select regions, calculate
averages, and modify the data otherwise.

---

## Part One:  A Simple Time Series

.center[<img src="images/fig_01_HadISST_global_and_annual_mean_SST_anomalies.png" width="90%">]

.center[**Figure 01.** *Annual-mean HadISST anomalies.*]

---

class: middle

## The Sloppy Way

**Figure 01.** *Annual-mean HadISST anomalies.*

--------

(Quite obvious) **problems**:

- Which **locations / times / regions** were included / excluded?

- What is the **reference period** for the anomalies?

- ...

---

## Giving More Details

**Figure 01.** *Global-mean and annual-mean HadISST anomalies relative to the
full period from 1900 to 2010.*

--

--------

We now know that

- the time series represents **global means**,

- the anomalies were calculated **relative to the complete time series**.

--

--------

But **still**:

- Could we be sure to find **exactly** the same data?

- Are those **weighted or arithmetic** spatial averages?

- How exactly and **in which order** did the authors calculate the temporal
  means / spatial means / temporal anomalies?

- …

---

class: middle

## Towards Full Repeatability

**Figure 01.** *Global-mean and annual-mean HadISST anomalies relative to the
full period from 1900 to 2010.  There are a Jupyter notebook and a data file
with all the details in the **supplementary materials**. *

---

class: middle

## The (essential parts of the) Supplementary Script

(Let's first walk through it.  We'll compare with your version of the analysis
later.)

---

### Calculating and Plotting the SST Anomalies

```python
import numpy as np
import xarray as xr

data_file = "/data/c2/TMdata/git_geomar_de_data/HadISST/v1.x.x/data/HadISST_sst.nc"

sst = xr.open_dataset(data_file).sst.sel(time=slice("1900-01-01", "2011-01-01"))
sst = sst.where(sst != -1000.0)


def wgt_glob_mean(data):
    cosine_latitude = np.cos(np.pi / 180.0 * data.coords["latitude"])
    data = ((cosine_latitude * data).sum(dim=["latitude", "longitude"])
            / (cosine_latitude + 0 * data).sum(dim=["latitude", "longitude"]))
    return data


def ann_mean(data):
    data = data.resample(time="12M").mean(dim="time")
    return data


def tmp_anom(data):
   data = data - data.mean("time")
   return data

sst_anomalies = tmp_anom(wgt_glob_mean(ann_mean(sst)))

sst_anomalies.plot()
```

[The full script is here.](https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/notebooks/fig_01_HadISST_global_and_annual_mean_SST_anomalies.ipynb)

---

class: middle

### Saving the Plotted Data for Reference

```python
output_data_set = xr.Dataset({"global_and_annual_mean_SST_anomalies": sst_anomalies})
output_data_set.to_netcdf(file_name)
```

[The full script is here.](https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/notebooks/fig_01_HadISST_global_and_annual_mean_SST_anomalies.ipynb)

---

## Data Provenance

We use a data set from a [fully version-controlled data
repository](https://git.geomar.de/data/HadISST/):

```python
data_file = Path("/data/c2/TMdata/git_geomar_de_data/HadISST/v1.x.x/data/HadISST_sst.nc")
```

--

--------

Moreover, the following tells us that we're using `v1.3.0` of the
`HadISST` data set:
```bash
git --work-tree="/data/c2/TMdata/git_geomar_de_data/HadISST/v1.x.x/" describe
```
```
v1.3.0
```

--

--------

To learn more about the data set, check:

- <https://git.geomar.de/data/HadISST/commits/v1.3.0> for a complete history of
  the our mirror of the data set,

- <https://git.geomar.de/data/HadISST> for a general overview, a README of the
  current version, etc.

---

class: middle

## Tools and Libraries

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
[...]
xarray                    0.9.6                    py35_0    conda-forge
xarray-0.9.6-51           g25d1855                  <pip>
xz                        5.2.3                         0    conda-forge
yaml                      0.1.6                         0    conda-forge
zeromq                    4.2.1                         1    conda-forge
zict                      0.1.3                      py_0    conda-forge
zlib                      1.2.8                         3    conda-forge
```

[The full script is here.](https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/notebooks/fig_01_HadISST_global_and_annual_mean_SST_anomalies.ipynb)

---

## Evolution of the Analysis

To see how this analysis developed in time, check:

<https://git.geomar.de/willi-rath/towards_reproducible_science/commits/master>

--

--------

This is a **time line** of every step towards the current version of this talk,
and the example analysis presented here.

Suppose, we developed the analysis as part of a multi-author paper.  Then, it
would be possible

- to **return to any earlier version** of the scripts at any later point,

- to **compare** scripts between **revisions** sent to the journal,

- to **roll back any changes** that are perhaps later found to be wrong,

but also

- to **merge** changes provided by collaborator,

- or to **discuss** proposed **changes before merging** them.

---

class: middle

## The Essence of Part One

Possible aspects of repeatability are

1. a small and easy-to-use data set containing **all the numbers** necessary to
   re-plot and compare the data presented in the analysis,

2. fully **documented steps** from the original data to the final presentation
   (plots, tables, etc.),

3. an overview of all the **tools** and **libraries** used in the analysis and
   of their exact versions,

4. a full **time-line** of the development of the analysis,

5. and a pointer to the full **raw data** used in the analysis (**data
   provenance**).

---

# Interlude

Let's now compare how you'd calculate a SST anomalies.

--

<img src="images/fig_02_HadISST_global_and_annual_mean_SST_anomalies_two_variants.png" width="85%">

[This notebook details a
subtlety with the order of averaging.](https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/notebooks/fig_02_HadISST_global_and_annual_mean_SST_anomalies_two_variants.ipynb)

---

# Interlude

Let's see how many variants there are.

<img src="images/fig_03_HadISST_global_and_annual_mean_SST_anomalies_all_variants.png" width="85%">

[This notebook shows 12 variants ...](https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/notebooks/fig_03_HadISST_global_and_annual_mean_SST_anomalies_all_variants.ipynb)


---

class: middle, left

## Part Two — Repeatable Workflows at Geomar

--

1. **all the numbers**

2. **documented steps**

3. **tools** and **libraries**

4. **time-line**

5. **raw data** and **data provenance**

--------

Currently, many journals are requiring authors to provide some form of **1.**
and / or **2.**.  But expect so see more and more requests for **3.** through
**5.**.

Here, we'll see how to **fullfill all** of **1.** through **5.** at Geomar.

---

class: middle

## "All The Numbers" (1.)

1. **all the numbers**

2. **documented steps**

3. **tools** and **libraries**

4. **time-line**

5. **raw data** and **data provenance**

---

## "All The Numbers" (1.) ← <https://data.geomar.de>

--

- meant to serve as a **stable** point of **first contact** for anybody looking
  for a dataset from Geomar

- today: **collection of links** to data for papers etc.

.medium[This is the place to put supplementary data and scripts!
←<datamanagement@geomar.de>]

--

--------

Some alternatives:

- At TM, we have <data-tm@geomar.de> which is forwarded to whoever is / will be
  in charge of data management within the group.

- https://zenodo.org provides storage and a DOI for data.

--

--------

*Note that the **hard part** is not providing a point of contact for those
requesting the data.  The hard part is **being able to provide the data** any
given time.*

---

class: middle

## "Documented steps" (2.)

1. **all the numbers** ← <https://data.geomar.de>

2. **documented steps**

3. **tools** and **libraries**

4. **time-line**

5. **raw data** and **data provenance**

---

class: middle

## "Documented steps" (2.) ← <https://nb.geomar.de>

- [Jupyter](https://github.com/jupyter/jupyter) **frontend** to virtually all
  the **large machines** (in-house and external)

- **beautifully rendered** analyses

- automatic **documentation** is (almost) **for free**

- most **Git** servers render Jupyter notebooks

--------

It is definitely possible (and currently done) to do *all* analyses in your PhD
project with Jupyter and on <https://nb.geomar.de>.

---

class: middle

## "Tools and Libraries" (3.)

1. **all the numbers** ← <https://data.geomar.de>

2. **documented steps** ← <https://nb.geomar.de>

3. **tools** and **libraries**

4. **time-line**

5. **raw data** and **data provenance**

---

class: middle

## "Tools and Libraries" (3.) ← [Conda environments](https://git.geomar.de/python/conda_environments/)

- use [Anaconda](https://www.anaconda.com/distribution/) (**Python** and **R**)
  and [Conda-Forge](https://conda-forge.org/) (far beyond)

- explicitly **manage** and **document** full working **environments**

- across **different machines**

- standard environments at Geomar:

  - <https://git.geomar.de/python/conda_environments/>

  - **already installed** on our analysis machines ←<https://nb.geomar.de>

---

class: middle

## "Time Line" (4.)

1. **all the numbers** ← <https://data.geomar.de>

2. **documented steps** ← <https://nb.geomar.de>

3. **tools** and **libraries** ← <https://git.geomar.de/python/conda_environments/>

4. **time-line**

5. **raw data** and **data provenance**


---

class: middle

## "Time Line" (4.) ← <http://git.geomar.de>

- **full-blown** version control environment

- for **Geomar members** and for **external collaborators**.

- **hosted here** (at Geomar)

- **easy** project management and **collaboration**

- continuous integration

- unlimited number of projects

- …

Introductory material: https://git.geomar.de/edu/git-intro

---

class: middle

## "Data Provenance" (5.)

1. **all the numbers** ← <https://data.geomar.de>

2. **documented steps** ← <https://nb.geomar.de>

3. **tools** and **libraries** ← <https://git.geomar.de/python/conda_environments/>

4. **time-line** ← <https://git.geomar.de>

5. **raw data** and **data provenance**

---

## "Data" (5.) ← <https://git.geomar.de/data/>

- **version controlled** external **data** with Git LFS

- tracking tens / hundreds of Terabytes (or more) of model output is beyond
  reach for now

--

--------

<https://git.geomar.de/data/docs/>

- Growing collection of external data sets.

- [Also available on the thredds
  server](https://data.geomar.de/thredds/catalog/tmdata/git_geomar_de_data/catalog.html)
  .small[← If you only klick on one link.  This is the one!]
--

--------

Current alternative for very large data sets:

- Work towards a **"single source of truth"**.

- Make sure to have **clear** (central?!) storage **structure**.

- ...

---

class: middle

## Building a Repeatable Workflow at Geomar

1. **all the numbers** ← <https://data.geomar.de>

2. **documented steps** ← <https://nb.geomar.de>

3. **tools** and **libraries** ← <https://git.geomar.de/python/conda_environments/>

4. **time-line** ← <https://git.geomar.de>

5. **raw data** and **data provenance** ← <https://git.geomar.de/data/>

---

## The (in my opinion) Best Part

- **only weak links** between components

- "plumbing" relies on **standard** sysadmin **skills**

--

--------

- ⇒ **limited effects** of failure / unavailability

- ⇒ profit **only** from what you **need**

- ⇒ **remain** fully **independent** from all other components

--

--------

If you **leave** Geomar, it is very easy to **take**

- all your **projects** from <https://git.geomar.de>,
- all your **data**,
- all your **notebooks**,
- setup scripts for conda **environments identical** to those available at
  Geomar,
- ...

---

class: middle

## But Do You Need This?

--

The **public debate** is focused on

- **fraud** prevention

- and facilitating communication **within the community**.

So we're fine.

... but are we?

---

class: left, middle

## But Do You Need This?

.center[<img src="images/sms_your_boss_airport.png" width="80%">]

---

class: left, middle

## But Do You Need This?

**You:** *"Can you check this sea-level trend against satellite data?"*

**Student:** *"... sure ..."* (about to leave for two weeks of googling for data)

**You:** *"Hey wait, [here's a
script](https://git.geomar.de/edu/python-intro/blob/master/Session_04/Session_04_02_xarray.ipynb)
where I did a similar thing with the [old AVISO
data](https://git.geomar.de/data/AVISO). Maybe it's good to start there.
When you're familiar with this one, adapt it to the new [SLTAC
product](https://git.geomar.de/data/SLTAC_GLO_PHY_L4_REP)."*

---

class: middle, center

# ~~But Do~~ You Need This !

---

## What Can *You* Do Now?

- Have a **mental framework** to think about repeatability. ← this talk

--

- **Script** all your analyses.  **Avoid interactive** work whenever possible.

- Keep **track** of **your data**.

- Have a standard of **numbering your versions**.  (Always forward.  There
  should be no files called `.txt.old`!)  ← [Semantic
  Versioning is a good start](http://semver.org/#summary)

----

- Learn to use **Git** or any other version-control system.

- And use it in your **daily routine** work.

----

Cheat-Sheets:

- Skim [Sandve (2013)][Sandve2013] for the **"10 Repeatability Commandments"**.

- Read the [reference sheet of Wilson (2012)][Wilson2012] to **be prepared for
  coding**.

---

class: middle

## What Do *We* Do Now?

Develop our **Culture:**

- Be(come more) **confident to publish** your code and data.

- Develop **ethics** of using code and data published by others.

- ...

Develop **Best Practices:**

- **How much** to document?

- **Where** to document?

- ...

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
