# chartcatalog 1.18.1

* Repair typo in who reference name

# chartcatalog 1.18.0

* Extends the lookup table with a new field `refpkg` that indicates the package where the reference with name `refcode` can be found

# chartcatalog 1.17.1

* Adds getters for inverse transformations of `x` and `y`

# chartcatalog 1.17.0

* Extends to `ynames_lookup` table with inverse transformation of `x` and `y`

# chartcatalog 1.16.0

* Update to roxygen 7.3.2

# chartcatalog 1.15.0

* Group terms into week 40 in `create_chartcode()`

# chartcatalog 1.14.0

* Adds `chartgrp` values `"gsed1"` and `"gsed1pt"` to support GSED Phase 1 references for the D-score

# chartcatalog 1.13.3

* Adds support for the `centile::load_reference()` function through the `refcode` field in `ynames_lookup`
* Adds a function `get_refcode()` to find the `refcode` for a given `chartcode` and `yname` 

# chartcatalog 1.13.2

* Sets the default D-score references in all charts to the GSED Phase 1 references

# chartcatalog 1.13.1

* Resolves an error in the logic of `create_chartcode()`

# chartcatalog 1.13.0

* Updates `parse_chartcode()` and  `create_chartcode()` to new preterm D-score charts
* Updates `ynames_lookup` table with preterm D-score charts

# chartcatalog 1.12.0

* Adds Phase 1 referencs to `ynames_lookup` table

# chartcatalog 1.11.0

* Adds WHO chart code for preterm so as to prepare for WHO D-score charts

# chartcatalog 1.10.0

* Adds four additional head circumference chart for Down syndrome
* Correct reference specifications for hdc of nl2010 charts in `ynames_lookup`

# chartcatalog 1.9.0

* Adds the Down Syndrome population to `parse_chartcode()`
* Expands `ynames_lookup` table with Down Syndrome charts

# chartcatalog 1.8.0

* Changes repo name to `growthcharts` in README and LICENCE

# chartcatalog 1.7.0

* Tranfers repo to <https://github.com/growthcharts/chartcatalog>
* Add GH actions `R-CMD-check` and `pkgdown`
* Creates `gh-pages` branch for online documentation

# chartcatalog 1.6.0

* Extends `get_breakpoints()` to accodomoate for donor choices `0-2`, `2-4` and `4-18`.

# chartcatalog 1.5.0

* Adds the `get_reference_call()` function to extract the proper call to `clopus`

# chartcatalog 1.4.0

* Reduced number of breakpoints for the terneuzen data

# chartcatalog 1.3.0

* Added D-score to `yname_lookup` table

# chartcatalog 1.2.0

* Added a `NEWS.md` file to track changes to the package.
