// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";

$(function() {
  $('.images').slick({
      dots: true,
      autoplay: true, // 自動再生を有効にする
      autoplaySpeed: 2000, // 自動再生の速さ（ミリ秒単位）
  });
});

document.addEventListener("DOMContentLoaded", function () {
    setTimeout(function () {
      document.getElementById("confirmationButtons").style.display = "block";
       // フェードインのアニメーション
      let opacity = 0;
      const fadeInInterval = setInterval(function () {
        if (opacity < 1) {
          opacity += 0.1;
          confirmationButtons.style.opacity = opacity;
        } else {
          clearInterval(fadeInInterval);
        }
      }, 100);
    }, 4000); // 3000ミリ秒 = 3秒
  });

