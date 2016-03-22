package sys.io;
using Lambda;
using haxe.io.Path;
using sys.FileSystem;
using sys.io.Path;

/**
 * @author SlavaRa
 */
class Directory {

	/**
	 * Возвращает имена файлов (включая пути) в заданном каталоге, отвечающие условиям шаблона поиска, используя значение, которое определяет, выполнять ли поиск в подкаталогах.
	 * @param path Каталог, в котором необходимо выполнить поиск.
	 * @param searchPattern Строка поиска, которую необходимо сравнивать с именами файлов, на которые указывает path.
	 * @param searchOption Одно из значений перечисления, определяющее, следует ли выполнять поиск только в текущем каталоге или также во всех его подкаталогах.
	 * @return 
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