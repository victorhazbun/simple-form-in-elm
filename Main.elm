module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import Json.Decode as Json
import Json.Encode as Encode


type alias Model =
    { email : String
    , message : String
    , submitting : Bool
    }


initialModel : Model
initialModel =
    { email = ""
    , message = ""
    , submitting = False
    }


type Msg
    = InputEmail String
    | InputMessage String
    | Submit
    | SubmitResponse (Result Http.Error ())


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
            ( { model | email = e }, Cmd.none )

        InputMessage m ->
            ( { model | message = m }, Cmd.none )

        Submit ->
            ( { model | submitting = True }, submit model )

        SubmitResponse _ ->
            ( model, Cmd.none )


submit : Model -> Cmd Msg
submit model =
    let
        url =
            "http://localhost:3000/api/contact"

        json =
            Encode.object
                [ ( "email", Encode.string model.email )
                , ( "message", Encode.string model.message )
                ]

        decoder =
            Json.string |> Json.map (always ())

        request =
            Http.post url (Http.jsonBody json) decoder
    in
        request |> Http.send SubmitResponse


view : Model -> Html Msg
view model =
    Html.form
        [ onSubmit Submit ]
        [ header
        , body
        , footer
        , div [] [ model |> toString |> text ]
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
                , onInput InputEmail
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
        [ button
            [ type_ "submit" ]
            [ text "Submit" ]
        , button
            [ type_ "button" ]
            [ text "Cancel" ]
        ]
