---
title: Creating a geospatial blog with Blogdown
author: Stephane Guillou and Mitchel Rudge
date: '2021-10-28'
slug: creating-a-geospatial-blog-with-blogdown
categories: []
tags:
  - r
  - rstudio
  - git
  - blogdown
---


### Good resources
https://www.apreshill.com/blog/2020-12-new-year-new-blogdown/
https://www.youtube.com/watch?v=x-Ch0-w1UhY
https://solomonkurz.netlify.app/post/2021-05-03-blogdown-updates-prompted-a-website-overhaul-these-are-my-notes/
https://bookdown.org/yihui/blogdown/installation.html

Prerequisites
-	Fairly recent version of R studio (RStudio IDE version, v1.4.1106 +)
-	Github account
-	GIT locally on computer. (Happy git with R https://happygitwithr.com/)
o	gitforwindows.org
o	Download GNU
o	Default on all settings
	Make sure to select Git from the command line and also from 3rd party software
-	Sign up for Netlify
Steps
1.	Create github repo
a.	Initialise with readme
b.	Don’t add .gitignore-
c.	Copy link https https://github.com/uqgeo-community/uqgeo_blogdown.git
2.	Create a new project
a.	File > new project > Version control > git
b.	Paste the URL from before
c.	Save the project somewhere sensible0
d.	Create project
3.	Create site
a.	Install.packages(“blogdown”)
b.	library(blogdown)
c.	new_site(theme = "wowchemy/starter-academic")
i.	choose a theme https://themes.gohugo.io/
ii.	“knadh/hugo-ink”
iii.	pacollins/hugo-future-imperfect-slim
d.	select y to let blogdown start a server for us. 
e.	blogdown::serve_site() #to serve site locally Click “show in new window” to properly preview
f.	There are two types of R markdown posts
i.	.Rmd to .html 
ii.	.Rmarkdown to .markdown (recommend .Rmarkdown)
g.	blogdown::new_post(title = "First post", ext = '.Rmarkdown', subdir = "post") #usually post but sometimes posts
h.	Can save a bunch of settings using
options(
  # to automatically serve the site on RStudio startup, set this option to TRUE
  blogdown.serve_site.startup = FALSE,
  # to disable knitting Rmd files on save, set this option to FALSE
  blogdown.knit.on_save = FALSE     <- change
  blogdown.author = "Alison Hill",  <- add
  blogdown.ext = ".Rmarkdown",      <- add
  blogdown.subdir = "post"          <- add
)
Restart R
i.	click the knit button
j.	Add R code chunk ‘’’{r}  
Summry(Orange)
‘’’
Then knit. 

Add more code. 

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-1-1.png" width="672" />
k.	If its not working, try blogdown::check_site() and get it fixed
4.	Using GitHub
a.	file.edit(“.gitignore”)
b.	Add 
.Rproj.user
.Rhistory
.RData
.Ruserdata
.DS_Store
Thumbs.db 
/public/
/resources/



c.	Blogdown::check_gitignore()
d.	Now check content
i.	blogdown::check_content()
ii.	

e.	the initial stage might not work, so do it through the shell. 
i.	Tools > shell 
Can configure git if it didn’t do it with a token. 
Git config –global user.name “username from github”
Git config –global user.email “email from github”
Then to stage all, git add -A
d
Commit > commit comment > push
5.	Publish site
a.	Sign up to Netlify using your GitHub account
b.	New Site from Git > Continuous Deployment: GitHub
c.	Select deploy site. Now it will automatically update every time you push changes to github
d.	Change site name general > site details > change site name
e.	Rstudioapi::navigateToFile(“config.yaml”, line = 3) make sure correct site name
f.	Blogdown::check_netlify()
i.	Select option 1
-	
