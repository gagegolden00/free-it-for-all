// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ChangeTextController from "./change_text_controller"
application.register("change-text", ChangeTextController)

import DarkModeController from "./dark_mode_controller"
application.register("dark-mode", DarkModeController)

import DropdownToggleController from "./dropdown_toggle_controller"
application.register("dropdown-toggle", DropdownToggleController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import ToggleHiddenController from "./toggle_hidden_controller"
application.register("toggle-hidden", ToggleHiddenController)
