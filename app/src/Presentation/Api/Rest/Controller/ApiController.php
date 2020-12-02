<?php

namespace App\Presentation\Api\Rest\Controller;

use App\Domain\Service\CompareTwoTextsFactory;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;

class ApiController extends AbstractController
{
    protected $possibleTxtFileNames = ['baconipsum','loremipsum','cupcakeipsum','pirateipsum'];

    /* application entry point, accept ipsum filenames from request, perform validation, do comparison and return response */

    /**
     * @Route("/v1/s1/{stream1}/s2/{stream2}")
     */
    public function index($stream1, $stream2): JsonResponse
    {
        if ((!in_array($stream1, $this->possibleTxtFileNames)) || (!in_array($stream2, $this->possibleTxtFileNames))) {
            return new JsonResponse([
                'status' => '404',
                'message' => 'Texts with provided params not found!',
                'params' => ['first_text'=> $stream1, 'second_text' => $stream2]]);

        } else {
            $compareFactory = new CompareTwoTextsFactory();
            $compare = $compareFactory->createCompareTwoTextsFactory($stream1, $stream2);

            $result = $compare->compareTexts();
            if ($result != 0) {
                $responseMessage = 'Searched texts differ in '.$result.' characters!';
            } else {
                $responseMessage = 'Two texts have no differences between!';
            }

            return new JsonResponse([
                'status' => '200',
                'char_differentiation' => $result,
                'message' => $responseMessage,
                'params' => ['first_text'=> $stream1, 'second_text' => $stream2]]);
        }
    }
}