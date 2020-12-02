<?php

namespace App\Domain\Service;

class CompareTwoTextsFactory
{

    public static function createCompareTwoTextsFactory($text1, $text2)
    {   
        $compareTwoTexts = new CompareTwoTexts($text1, $text2);
        
        return $compareTwoTexts;
    }
}