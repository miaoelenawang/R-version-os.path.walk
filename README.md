## R-version-os.path.walk
### A function similar to Python's os.path.walk()
<p>The call form will be walk(currdir,f,arg,firstcall=TRUE)</p>
<p> where the arguments are:</p>
<ul>
<li>currdir: starting directory for the current call</li>
<li>f: user-defined function, with arguments
<ul>
<li>dname: Name of the directory within which the function is called.</li>
<li>flist: A list of files in that directory. This will be supplied to f() by walk().</li>
<li>arg: An input to some running computation, say a sum. In the course of recursion, the output of walk() (initially, the output of f()) will be input to f().</li></ul>
<li>firstcall: if TRUE, this is the first of recursive calls</li>
</ul>