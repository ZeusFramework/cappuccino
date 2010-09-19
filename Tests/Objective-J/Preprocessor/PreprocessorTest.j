
var FILE = require("file"),
    compressor = require("minify/shrinksafe");

var FILENAMES = [
        "Class", "ClassWithIvar", "ClassWithIvars"
                ];

@implementation PreprocessorTest : OJTestCase
{
}

+ (void)initialize
{
    var index = 0,
        count = FILENAMES.length;

    for (; index < count; ++index)
    {
        var filename = FILENAMES[index],
            testSelector = sel_getUid("test" + FILENAMES[index])

        class_addMethod(self, testSelector, function(self, _cmd)
        {
            var filePath = FILE.join(FILE.dirname(module.path), "Sources", filename + ".j"),
                unpreprocessed = FILE.read(filePath, { charset:"UTF-8" });
                preprocessed = ObjectiveJ.preprocess(unpreprocessed).code(),
                correct = FILE.read(FILE.join(FILE.dirname(module.path), "Sources", filename + ".js"));

            preprocessed = compressor.compress(preprocessed, { charset : "UTF-8", useServer : true });
            correct = compressor.compress(correct, { charset : "UTF-8", useServer : true });

            [self assert:preprocessed equals:correct];
        });
    }
}

@end

[PreprocessorTest alloc];