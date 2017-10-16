class: middle, left

# Repeatable Work Flows

_Willi Rath_ (<wrath@geomar.de>)

.medium[**Thanks:** *Martin Claus, Claus Böning, Torge Martin, Markus
Scheinert, Klaus Getzlaff, Christina Roth, Geomar Data Management Team, Geomar
IT Department, ...*]

---

class: middle, center

<img src="images/Easterbrook2014_ngeo2283-f1.jpg" width="99%">

.small[.right[From [Easterbrook (2014)][Easterbrook2014]]]

---

class: middle, left

## ~~Reproducible~~ Repeatable Work Flows

_ Let's say an analysis is **repeatable**, if for any **sufficiently skilled**
reader it is **in principle** possible to **completely understand** and
**repeat all steps** the author took from their initial idea to the final
conclusions. _

⇒ Which **input data** were used?

⇒ What are the **steps** from the initial data to the **final numbers** and figures?

⇒ **Why** did the authors do what they did?

⇒ …

---

class: middle, left

## Part One — An Example Analysis

*A time series of global-mean sea-surface-temperature anomalies*

## Part Two — Repeatable Workflows

*We **do** have all the building blocks for a repeatable work flow at Geomar !*

---

class: middle, left

## Challenge

Those of you who have an idea what the following plot shows:

- _ Please  **take a note** (in pseudo-code or code) on how you would produce
  it. _

- _ Please be **specific** about **when** and **how** you select regions,
  calculate averages, and modify the data otherwise. _

---

## Part One:  A Simple Time Series

.center[<img src="images/fig_01_HadISST_global_and_annual_mean_SST_anomalies.png" width="95%">]

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

--------

We now know that

- the time series represents **global means**,
- the anomalies were calculated **relative to** the **complete time series**.

--

--------

But still:

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

## The Supplementary Material

- There is a [Jupyter notebook][fig_01_notebook_on_git] that contains the full
  analysis from the initial HadISST fields to the final plot.

- There is a [data file][fig_01_data_file_on_git] that contains all numbers used
  to produce the figure.


---

### The Jupyter Notebook

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

_ .right[This code shows the essential parts of the analysis. [The full notebook is here.][fig_01_notebook_on_git]] _

---

class: middle

### Saving the Plotted Data for Reference

```python
[...]
output_data_set = xr.Dataset({"global_and_annual_mean_SST_anomalies": sst_anomalies})
output_data_set.to_netcdf(file_name)
[...]
```

_ .right[[Click here for the full notebook][fig_01_notebook_on_git] and [here for the data file.][fig_01_data_file_on_git]] _

---

class: left, middle

## Raw Data

We use the [HadISST data set][HadISST_on_git] from a
[repository][git_geomar_de_data_docs] of fully version-controlled data sets:

```python
[...]
data_file = Path("/data/c2/TMdata/git_geomar_de_data/HadISST/v1.x.x/data/HadISST_sst.nc")
[...]
```

--------

From within the notebook, we find out that at the time of the analysis,
`HadISST` `v1.3.0` was the latest of the `v1.x.x` versions:
```bash
git --work-tree="/data/c2/TMdata/git_geomar_de_data/HadISST/v1.x.x/" describe
```
```bash
v1.3.0
```

---

class: left, middle

## Raw Data

_ "We used v1.3.0 of the HadISST data set from our [internal mirror][git_geomar_de_data]." _

--------

This **completely defines** the raw data:

- General information: <https://git.geomar.de/data/HadISST>

- Full history up to version v1.3.0: <https://git.geomar.de/data/HadISST/commits/v1.3.0>

- Other data sets, examples, download requests: <https://git.geomar.de/data/docs/>

---

class: middle

## Tools and Libraries

Within the [Jupyter notebook][fig_01_notebook_on_git], we list the complete
Python environment that was activated during the analysis:

```bash
conda list
```
```bash
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

---

class: left, middle

## Evolution of the Analysis

The development of the analysis (and of this talk) was tracked on [the Geomar
Git server][git_geomar_de].

To see how it developed in time, check:<br><https://git.geomar.de/willi-rath/towards_reproducible_science/commits/master>

--------

Suppose, this was a multi-author paper.  Then, it would be easy to

- **return to any earlier version** of the scripts at any later point,

- **compare** scripts between **revisions** sent to the journal, or

- **roll back** any **changes** that are perhaps later found to be wrong.

---

class: middle

# The Essence of Part One

Break repeatability by skipping at least one of:

1. a data set containing **all the numbers** necessary to re-plot and compare
   the data **presented in the analysis**

2. fully **documented steps** from the original data to the final presentation

3. an overview of all the **tools** and **libraries** used in the analysis and
   of their exact versions

4. a pointer to the full **raw data** used in the analysis

5. a full **time-line** of the development of the analysis _← that's more of a bonus_

---

class: middle, left

# Interlude

Let's compare different ways to calculate the SST anomalies.

.center[<img src="images/fig_01_HadISST_global_and_annual_mean_SST_anomalies.png" width="80%">]

.right[.medium[*... need your notes*]]

---

# Interlude - Two Lines

[This notebook][fig_02_notebook_on_git] details a subtlety with the order of
averaging:

.center[<img src="images/fig_02_HadISST_global_and_annual_mean_SST_anomalies_two_variants.png" width="80%">]

---

# Interlude - Twelve Lines

[This notebook][fig_03_notebook_on_git] also considers arithmetic averages and
shows all 12 variants:

.center[<img src="images/fig_03_HadISST_global_and_annual_mean_SST_anomalies_all_variants.png" width="80%">]

.right[.medium[*... note that we're still weighting all months equally.*]]

---

class: middle, center

# Part Two

---

class: middle, left

## Repeatable Workflows at Geomar

1. **all the numbers**

2. **documented steps**

3. **tools** and **libraries**

4. **raw data** and **data provenance**

5. **time-line**

--------

Currently, many journals are requiring authors to provide some form of **steps 1**
and **2**.

But be prepared to see requests for **step 3** through **5**!

---

class: left, middle

## "All the Numbers" ← [data.geomar.de][data_geomar_de]

_ To publish your data and supplementaries, contact <datamanagement@geomar.de>. _

- **Stable** point of **first contact** for anybody looking for a dataset from
  Geomar

- Today: **collection of links** to data for papers etc.

--------

- At TM, we have <data-tm@geomar.de> which is forwarded to whoever is / will be
  in charge of data management within the group.

- https://zenodo.org provides storage and a DOI for data.

---

class: middle

## "Documented steps"

1. **all the numbers** ← [https://data.geomar.de][data_geomar_de]

2. **documented steps**

3. **tools** and **libraries**

4. **raw data** and **data provenance**

5. **time-line**

---

class: middle

## "Documented steps" ← [nb.geomar.de][nb_geomar_de]

- [Jupyter][jupyter_github] **frontend** to virtually all
  the **large machines** (in-house and external)

- **beautifully rendered** analyses

- automatic **documentation** is (almost) **for free**

- **Git** servers render Jupyter notebooks

--------

It is definitely possible (and currently done) to do *all* analyses in your PhD
project with Jupyter and on [https://nb.geomar.de][nb_geomar_de].

---

class: middle

## "Tools and Libraries"

1. **all the numbers** ← <https://data.geomar.de>

2. **documented steps** ← <https://nb.geomar.de>

3. **tools** and **libraries**

4. **raw data** and **data provenance**

5. **time-line**

---

class: middle

## "Tools and Libraries" ← [Conda Envs][git_geomar_de_python_conda_environments]

- use [Anaconda][anaconda] (**Python** and **R**)
  and [Conda-Forge][conda_forge] (far beyond)

- explicitly **manage** and **document** full working **environments**

- across **different machines**

- standard environments at Geomar:

  - <https://git.geomar.de/python/conda_environments/>

  - **already installed** on our analysis machines ←<https://nb.geomar.de>

---

class: middle

## "Raw Data"

1. **all the numbers** ← <https://data.geomar.de>

2. **documented steps** ← <https://nb.geomar.de>

3. **tools** and **libraries** ← <https://git.geomar.de/python/conda_environments/>

4. **raw data** and **data provenance**

5. **time-line**

---

class: middle, left

## "Raw Data" ← [git.geomar.de/data/][git_geomar_de_data_docs]

- fully **version controlled** external **data** Git LFS

- for now, tracking tens / hundreds of Terabytes of model output is beyond reach

--------

To learn more, check: <https://git.geomar.de/data/docs/>

- **Growing** collection of external data sets.

- [Also available on the thredds
  server][git_data_on_thredds]
  .small[← If you only klick on one link.  This is the one!]

---

class: middle

## Thoughts on Very Large Data Sets

- Work towards a **"single source of truth"**!

- Make sure to have **clear** (central?!) storage **structure**!

- **Plan for evolution** of each data set right from the start!

- Think about how number versions.  [This might be a good starting point.][semver_for_data_on_git]

- ...

---

class: middle

## "Time Line"

1. **all the numbers** ← <https://data.geomar.de>

2. **documented steps** ← <https://nb.geomar.de>

3. **tools** and **libraries** ← <https://git.geomar.de/python/conda_environments/>

4. **raw data** and **data provenance** ← <https://git.geomar.de/data/docs>

5. **time-line**

---

class: middle

## "Time Line" ← [git.geomar.de][git_geomar_de]


- **full-blown** version control environment

- for **Geomar members** and for **external collaborators**.

- **hosted here** (at Geomar)

- **easy** project management and **collaboration**

- continuous integration

- unlimited number of projects

- …

Introductory materials: <https://git.geomar.de/edu/git-intro>

---

class: middle

## Repeatable Workflows at Geomar

1. **all the numbers** ← <https://data.geomar.de>

2. **documented steps** ← <https://nb.geomar.de>

3. **tools** and **libraries** ← <https://git.geomar.de/python/conda_environments/>

4. **raw data** and **data provenance** ← <https://git.geomar.de/data/docs>

5. **time-line** ← <https://git.geomar.de>

---

class: middle, left

## The (in my opinion) Best Part

- **only weak links** between components
- "plumbing" relies on **standard** sysadmin **skills**

--

--------

- ⇒ **limited effects** of failure / unavailability of a component
- ⇒ profit **only** from what you **need**
- ⇒ **remain** fully **independent** from all other components

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

# But Do You Need This?

The **public debate** is often focused on **fraud prevention** in the medical
sciences.

.right[ So we're fine! _ ... but are we? _ ]

---

class: left, middle

# But Do You Need This?

.center[<img src="images/sms_your_boss_airport.png" width="80%">]

---

class: left, middle

# But Do You Need This?

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


class: middle, left

## What Do **You** Do Now?

- Have a **mental framework** to think about repeatability. ← this talk

- **Script** all your analyses.  **Avoid interactive** work whenever possible.

- Keep **track** of **your data**.

----

- Learn to use **Git** or any other version-control system.

- And use it in your **daily routine** work.

---

class: middle

## What Do **We** Do Now?

Develop our **Culture:**

- Be **confident to publish** your code and data.

- Develop **ethics** of using code and data published by others.

- ...

Develop **Best Practices:**

- **How much** to document?

- **Where** to document?

- ...

---

class: medium, middle

### Resources for repeatable work flows

Cheat Sheets:

- [Sandve (2013)][Sandve2013] has the **"10 Repeatability Commandments"**.
- [Wilson (2012)][Wilson2012] has a reference sheet to **be prepared for
  coding**.

Resources at Geomar:

- Geomar Git server: [https://git.geomar.de][git_geomar_de]
- central Jupyter notebook server:
  - [https://nb.geomar.de][nb_geomar_de]
  - [https://git.geomar.de/python/doc/blob/master/nb_user_guide.md][nb_user_guide]
- central data repository:
  - start here: [https://git.geomar.de/data/docs/][git_geomar_de_data_docs]
  - and: [https://data.geomar.de/thredds/catalog/tmdata/git_geomar_de_data/catalog.html][git_data_on_thredds]
- conda environments:
  - our standard envs: [https://git.geomar.de/python/conda_environments/][git_geomar_de_python_conda_environments]
  - Conda Forge: [https://conda-forge.org/][conda_forge]
  - Anaconda: [https://www.anaconda.com/distribution/][anaconda]
- publish data on: [https://data.geomar.de][data_geomar_de]
- how to number versions:
  - for data: [https://git.geomar.de/data/docs/blob/master/versioning.md][semver_for_data_on_git]
  - semantic versioning (the meaning behing `v12.14.7` et al.): http://semver.org

Nice tools and software:

- Anaconda's Python distribution: [https://www.anaconda.com/distribution/][anaconda]
- Conda Forge: [https://conda-forge.org/][conda_forge]
- Jupyter notebooks: [https://github.com/jupyter/jupyter][jupyter_github]

---

class: medium

### Figures from this talk

- Notebook for Figure 01: [https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/notebooks/fig_01_HadISST_global_and_annual_mean_SST_anomalies.ipynb][fig_01_notebook_on_git]
- Data for Figure 01: [https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/data/fig_01_HadISST_global_and_annual_mean_SST_anomalies.nc][fig_01_data_file_on_git]
- Notebook for Figure 02:<br> [https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/notebooks/fig_02_HadISST_global_and_annual_mean_SST_anomalies_two_variants.ipynb][fig_02_notebook_on_git]
- Data for Figure 02:<br> <https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/data/fig_02_HadISST_global_and_annual_mean_SST_anomalies_two_variants.nc>
- Notebook for Figure 03:<br> [https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/notebooks/fig_03_HadISST_global_and_annual_mean_SST_anomalies_all_variants.ipynb][fig_03_notebook_on_git]
- Data for Figure 03:<br> <https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/data/fig_03_HadISST_global_and_annual_mean_SST_anomalies_all_variants.nc>
- HadISST data set: [https://git.geomar.de/data/HadISST/][HadISST_on_git]

### Reading list

- _"Publish your computer code: it is good enough"_ : [https://www.nature.com/news/2010/101013/full/467753a.html][Barnes2010]
- _"Open code for open science?"_ : [http://www.nature.com/ngeo/journal/v7/n11/full/ngeo2283.html][Easterbrook2014]
- _"Why bitwise reproducibility matters"_ : [https://khinsen.wordpress.com/2015/01/07/why-bitwise-reproducibility-matters/][Hinsen2015]
- _"Which mistakes do we actually make in scientific code?"_ : [http://blog.khinsen.net/posts/2017/05/04/which-mistakes-do-we-actually-make-in-scientific-code/][Hinsen2017]
- _"A Minimum Standard for Publishing Computational Results in the
Weather and Climate Sciences"_ : [http://journals.ametsoc.org/doi/full/10.1175/BAMS-D-15-00010.1][Irving2015]
- _"Good Scientific Practice at MPI-M"_ : [http://www.mpimet.mpg.de/en/science/publications/good-scientific-practice.html][MPI_good_scientific_practice]
- _"Nature - Code share"_ : [https://www.nature.com/news/code-share-1.16232][Nature_CodeShare]
- _"Ten Simple Rules for Reproducible Computational Research"_ : [http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1003285][Sandve2013]
- _"Best Practices for Scientific Computing"_ : [https://arxiv.org/abs/1210.0530][Wilson2012]
- _"Most computational hydrology is not reproducible, so is it really science?"_: [http://onlinelibrary.wiley.com/doi/10.1002/2016WR019285/full][Hutton2016]
    - first comment: [http://onlinelibrary.wiley.com/doi/10.1002/2016WR020190/full][Anel2016]
    - first reply: [http://onlinelibrary.wiley.com/doi/10.1002/2017WR020480/full][Hutton2017a]
    - second comment: [http://onlinelibrary.wiley.com/doi/10.1002/2016WR020208/full][Melsen2017]
    - second reply: [http://onlinelibrary.wiley.com/doi/10.1002/2017WR020476/full][Hutton2017b]


[anaconda]: https://www.anaconda.com/distribution/

[conda_forge]: https://conda-forge.org/

[data_geomar_de]: https://data.geomar.de

[fig_01_notebook_on_git]: https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/notebooks/fig_01_HadISST_global_and_annual_mean_SST_anomalies.ipynb

[fig_01_data_file_on_git]: https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/data/fig_01_HadISST_global_and_annual_mean_SST_anomalies.nc

[fig_02_notebook_on_git]: https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/notebooks/fig_02_HadISST_global_and_annual_mean_SST_anomalies_two_variants.ipynb

[fig_03_notebook_on_git]: https://git.geomar.de/willi-rath/towards_reproducible_science/blob/master/notebooks/fig_03_HadISST_global_and_annual_mean_SST_anomalies_all_variants.ipynb

[git_data_on_thredds]: https://data.geomar.de/thredds/catalog/tmdata/git_geomar_de_data/catalog.html

[git_geomar_de]: https://git.geomar.de

[git_geomar_de_data]: https://git.geomar.de/data/

[git_geomar_de_data_docs]: https://git.geomar.de/data/docs/

[git_geomar_de_python_conda_environments]: https://git.geomar.de/python/conda_environments/

[HadISST_on_git]: https://git.geomar.de/data/HadISST/

[jupyter_github]: https://github.com/jupyter/jupyter

[nb_geomar_de]: https://nb.geomar.de

[nb_user_guide]: https://git.geomar.de/python/doc/blob/master/nb_user_guide.md

[semver_for_data_on_git]: https://git.geomar.de/data/docs/blob/master/versioning.md



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

[Hutton2016]: http://onlinelibrary.wiley.com/doi/10.1002/2016WR019285/full

[Anel2016]: http://onlinelibrary.wiley.com/doi/10.1002/2016WR020190/full

[Hutton2017a]: http://onlinelibrary.wiley.com/doi/10.1002/2017WR020480/full

[Melsen2017]: http://onlinelibrary.wiley.com/doi/10.1002/2016WR020208/full

[Hutton2017b]: http://onlinelibrary.wiley.com/doi/10.1002/2017WR020476/full
