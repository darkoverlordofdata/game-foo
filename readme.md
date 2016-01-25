pa# GameFoo

A simple game in Vala using assets from LazyFoo examples for SDL2





# Build


Valama has some issues:
* Not much in the way of editing commands.
* There are no line numbers. Compile errors give you line numbers.

I Use Valama to create project, generate the build system, and browse the object models.
I use SublimeText to fill in the gaps durning the edit / debug cycle. 


~/.config/sublime-text-3/Packages/User/Vala.sublime-build

```json
{
	"shell_cmd": "cp -R -n ./resources ./build cd build && make && ./${project_base_name}",
	"working_dir": "${project_path:${folder}}",
	"file_regex": "^(?<filename>(?:[A-Z]:)?[^:]+):(?<line>[0-9]+).(?<column>[0-9]+)[^:]+: (?<message>.+)"
}
```