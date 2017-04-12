walk <- function(currdir,f,arg,firstcall=TRUE){
  if (firstcall == TRUE){
    lastdir = getwd()
  }
  
  setwd(currdir) # "push" currdir onto the path
  
  # calculate 'f' for current directory
  filelist = dir()
  arg = f(currdir,filelist,arg)
  
  # note: we must re-grab dir() due to the possibility that f changes
  #       files/folders in the current directory. e.g. f = rmemptydirs
  Info = file.info(dir())
  drnamelist = rownames(Info)[Info$isdir == TRUE]
  
  # recurse through child directories
  for (drname in drnamelist){
    # call 'walk' to execute f on the next dir (and any subdirectories)
    arg = walk(drname, f, arg, firstcall = FALSE)
  }
  
  # make sure we end in the same working directory that we started in
  if (firstcall == TRUE){
    setwd(lastdir)
  } else {
    setwd('..') # "pop" currdir from path
  }
  
  return (arg)
}

# rmemptydirs example
# file tree:
# /ex
# ├── /empty1
# ├── /empty2
# │   └── /sub_empty
# ├── /nonempty
# │   └── file.txt

# 1. walk("ex", rmemptydirs, 0)
#    |__> empty1 is removed
#    |__> 2. walk("empty2", rmemptydirs, 0)
#            |__> sub_empty is removed
#    |__> 3. walk("nonempty", rmemptydirs, 0)
#            (no folders to remove)

# end result:
# /ex
# ├── /empty2
# ├── /nonempty
# │   └── file.txt


# nbytes example
# file tree:
# ├── /docs
# |   └── /school
# |   |   ├── essay.doc [20 bytes]
# |   |   └── homework.txt [15 bytes]
# │   └── /temp
# |       └── text.txt [5 bytes]
# ├── notes.txt [10 bytes]
# └── /pictures
# |   ├── pic1.jpg [25 bytes]
# |   └── pic2.jpg [37 bytes]

# 1. walk("ex", nbytes, 0)
#    |__> files in ex counted
#         * notes.txt [10]
#    |__> 2. walk("docs", nbytes, 10)
#         (no files to count)
#            |__> 3. walk("school", nbytes, 10)
#                    |__> files in school counted
#                         * essay.doc [30]
#                         * homework.txt [45]
#            |__> 4. walk("temp", nbytes, 45)
#                    |__> files in temp counted
#                         * text.txt [50]
#    |__> 5. walk("pictures", nbytes, 50)
#            |__> files in pictures counted
#                 * pic1.jpg [75]
#                 * pic2.jpg [112]
# 112 returned.

# find the total number of bytes in all the (nondirectory) files
nbytes <- function(drname,filelist,arg){
  size = 0
  # loop over filelist
  for (fname in filelist){
    # only add nondirectory's size to arg
    if (!file.info(fname)[fname,'isdir']){
      size = size + file.info(fname)[fname,'size']
    }
  }
  return (arg + size) 
} 


# remove all the empty directories.
rmemptydirs <- function(drname,filelist,arg){ 
  # loop over filelist
  for (fname in filelist){
    # check whether this file is an empty directory
    if (file.info(fname)[fname,'isdir'] && length(dir(fname))==0){
      # remove that directory
      file.remove(fname)
    }
  }
}


walk("Book",rmemptydirs,0)

