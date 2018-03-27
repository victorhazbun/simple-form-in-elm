module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { email : String
    , message : String
    }


initialModel : Model
initialModel =
    { email = ""
    , message = ""
    }


type Msg
    = InputEmail
    | InputMessage
    | Submit


main : Program Never Model Msg
main =
    program
        { init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \model -> Sub.none
        , view = view
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
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
