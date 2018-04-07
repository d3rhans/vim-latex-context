# vim-latex-context

Vim Latex context is a small vim plugin, that determines the context within a latex document on
request. Contexts are:

* Math environment
* File name environment (e.g., in \input{|})
* Cite environment (e.g., in \cite{|})
* ...

The plugin does not do much more than return information on the current environment when the
VLXgetContext command is called.

This may be usefull in combination with other plugins/functions e.g., expanding math snippets only
in a math environment, triggering different omnifuncs etc.
