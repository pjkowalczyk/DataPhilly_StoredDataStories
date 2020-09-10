# DataPhilly_StoredDataStories
Materials for the DataPhilly Fall Workshop: 'From Stored Data To Data Stories'

Greetings / Salvete / Schöne Grüße / Salutations / Pozdrowienia

### Before the Workshop ... ###  
* Required software  
  * **R**: Install the latest version of R from the Comprehensive R Archive Network ([CRAN](https://cran.r-project.org)).  
  * **RStudio**: Install the RStudio integrated development environment, available from ([RStudio, Inc.](https://www.rstudio.com))  
  * **Python** & **Jupyter Notebook**: Install Python and the Jupyter Notebook (and more of the Python machine learning ecosystem) by installing [Anaconda](https://www.anaconda.com/products/individual).
  * **LaTeX**: LaTeX needs to be installed to generate PDF output. It's recommended that R Markdown users who have not installed LaTeX install **[TinyTeX](https://yihui.name/tinytex/)**.<sup>[1](#RMarkdown)</sup> To do so, execute the following commands (in an R session):  
            <br>
            &nbsp;&nbsp;&nbsp;&nbsp;install.packages("tinytex")  
            &nbsp;&nbsp;&nbsp;&nbsp;library(tinytex)  
            &nbsp;&nbsp;&nbsp;&nbsp;tinytex::install_tinytex()  
            <br>
* Required packages  
   * **R**: I'll be making use of **[pacman](https://github.com/trinker/pacman)**, a package management tool for R. This tool will load libraries and - *conveniently* - install those libraries that need to be installed. 
   * **Python**: <img src = '/images/UnderConstruction.png' width='100' height='35'>  
<br>
* A few test cases (if these run successfully, you're good-to-go)  

***  
<a name="RMarkdown">1</a>: Xie, Yihui, Joseph J. Allaire, and Garrett Grolemund. *R markdown: The definitive guide.* CRC Press, 2018.
