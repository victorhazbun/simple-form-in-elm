module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


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
    = InputEmail String
    | InputMessage String
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
    case msg of
        InputEmail e ->
            ( { model | email = String.toLower e }, Cmd.none )

        InputMessage m ->
            ( { model | message = m }, Cmd.none )

        Submit ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.form []
        [ header
        , body model
        , footer
        , div [] [ model |> toString |> text ]
        ]


header =
    div []
        [ h1 [] [ text "Contact us" ] ]


body model =
    div []
        [ div []
            [ input
                [ placeholder "your email"
                , type_ "email"
                , onInput InputEmail
                , value model.email
                ]
                []
            ]
        , div []
            [ textarea
                [ placeholder "your message"
                , rows 7
                , onInput InputMessage
                ]
                []
            ]
        ]


footer =
    div []
        [ button [] [ text "Submit" ] ]
