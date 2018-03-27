module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


main : Html a
main =
    Html.form
        []
        [ div []
            [ h1 [] [ text "Contact us" ] ]
        , div []
            [ input
                [ placeholder "your email"
                , type_ "email"
                ]
                []
            ]
        , div []
            [ textarea
                [ placeholder "your message"
                , rows 7
                ]
                []
            ]
        , div []
            [ button [] [ text "Submit" ] ]
        ]
