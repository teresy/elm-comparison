signUpForTakeHomeView : TestConfig -> Html
signUpForTakeHomeView testConfig =
    form
        [ action routes.signup
        , method "POST"
        , enctype "multipart/form-data"
        ]
        [ stylesheetLink assets.signup.route
        , div
            [ class SignupFormContainer ]
            [ emailField
            , applicationIdField
            , chooseRole (List.map (\test -> test.name) testConfig.tests)
            , submitField
            ]
        ]


alreadySignupView : String -> User -> Html
alreadySignupView url user =
    div
        []
        [ text "You've already signed up! "
        , a
            [ href url ]
            [ text url ]
        ]


successfulSignupView : String -> User -> Html
successfulSignupView url user =
    div
        []
        [ a
            [ href url ]
            [ text ("You have successfully signed up, " ++ user.name) ]
        ]


chooseRole : List String -> Html
chooseRole choices =
    let
        roles =
            List.map
                (\role -> option [] [ text role ])
                choices
    in
        select
            [ id "role"
            , name "role"
            , class InputField
            ]
            roles
