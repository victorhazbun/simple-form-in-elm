module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


main : Html a
main =
    div
        [ id "hello"
        , class "my-class"
        ]
        [ text "Hello Forms!" ]
