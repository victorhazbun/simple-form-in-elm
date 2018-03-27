module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


main : Html a
main =
    Html.form []
        [ header
        , body
        , footer
        ]


header =
    div []
        [ h1 [] [ text "Contact us" ] ]


body =
    div []
        [ div []
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
        ]


footer =
    div []
        [ button [] [ text "Submit" ] ]
