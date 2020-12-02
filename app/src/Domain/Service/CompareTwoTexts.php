<?php

namespace App\Domain\Service;

class CompareTwoTexts
{
    protected $text1;
    protected $text2;

    public function __construct($text1, $text2)
    {
        $this->text1 = $text1;
        $this->text2 = $text2;
    }

    /* read files based passed filename, perform comparison and return result */
    public function compareTexts()
    {
        $t1 = $this->readFile($this->text1);
        $t2 = $this->readFile($this->text2);

        $comparisonResult = $this->compare($t1, $t2);

        return $comparisonResult;
    }

    /* read file based on passed filename */
    protected function readFile($textname)
    {
        $txt_file = file_get_contents("lib/{$textname}.txt", FILE_USE_INCLUDE_PATH);

        return $txt_file;
    }

    /* compare two texts, comparison is based od levelshtein algorithm */
    /* The levenshtein() function returns the Levenshtein distance between two strings.
        The Levenshtein distance is the number of characters you have to replace,
        insert or delete to transform string1 into string2
    */
    protected function compare($txt1, $txt2)
    {
        $comparisonResult = levenshtein($txt1, $txt2);
        
        return $comparisonResult;
    }
}