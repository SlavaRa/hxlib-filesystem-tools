package system.io;
using Lambda;
using haxe.io.Path;
using sys.FileSystem;
using system.io.Path;

class Directory {

	/**
	 * Returns the names of files (including their paths) that match the specified search pattern in the specified directory.
	 * @param path The relative or absolute path to the directory to search. This string is not case-sensitive.
	 * @param searchPattern The search string to match against the names of files in path. This parameter can contain a combination of valid literal path and wildcard (* and ?) characters (see Remarks), but doesn't support regular expressions.
	 * @param searchOption One of the enumeration values that specifies whether the search operation should include all subdirectories or only the current directory.
	 * @return An array of the full names (including paths) for the files in the specified directory that match the specified search pattern and option, or an empty array if no files are found.
	 */
	public static inline function getFiles(path:String, searchPattern:String, searchOption:SearchOption):Array<String> {
		return _getFiles(path.addTrailingSlash(), searchPattern, searchOption, []);
	}
	
	static function _getFiles(path:String, pattern:String, option:SearchOption, result:Array<String>):Array<String> {
		var all = pattern.indexOf("*.*") != -1;
		var paths = path.readDirectory();
		paths = paths.map(function(p) return path.combine2(p));
		result = result.concat(paths.filter(function(p) return !p.isDirectory() && (all || p.extension().indexOf(pattern) != -1)));
		if(option == SearchOption.AllDirectories) {
			for(it in paths.filter(FileSystem.isDirectory)) {
				result = result.concat(_getFiles(it.addTrailingSlash(), pattern, option, []));
			}
		}
		return result;
	}
}
