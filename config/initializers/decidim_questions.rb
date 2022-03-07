# frozen_string_literal: true

Decidim::QuestionCaptcha.configure do |config|
  config.questions = {
      en: [
          { "question" => "1+5", "answers" => "six" },
          { "question" => "2+2", "answers" => "four" },
          { "question" => "3+3", "answers" => "six" },
          { "question" => "4+2", "answers" => "six" }
      ],
      es: [
          { "question" => "0+0", "answers" => "zero" },
          { "question" => "3+4", "answers" => "siete" },
          { "question" => "4+4", "answers" => "ocho" },
          { "question" => "2+2", "answers" => "cuatro" }
      ],
      ca: [
          { "question" => "8+1", "answers" => "nou" },
          { "question" => "3+4", "answers" => "set" },
          { "question" => "4+4", "answers" => "vuit" },
          { "question" => "2+2", "answers" => "quatre" }
      ]
  }
end
