# frozen_string_literal: true

Decidim::QuestionCaptcha.configure do |config|
  config.questions = {
      en: [
          { "question" => "1+5", "answers" => "6,six" },
          { "question" => "2+2", "answers" => "4,four" },
          { "question" => "3+3", "answers" => "6,six" },
          { "question" => "4+2", "answers" => "6,six" }
      ],
      es: [
          { "question" => "0+0", "answers" => "0,zero" },
          { "question" => "3+4", "answers" => "7,siete" },
          { "question" => "4+4", "answers" => "8,ocho" },
          { "question" => "2+2", "answers" => "4,cuatro" }
      ],
      ca: [
          { "question" => "8+1", "answers" => "9,nou" },
          { "question" => "3+4", "answers" => "7,set" },
          { "question" => "4+4", "answers" => "8,vuit" },
          { "question" => "2+2", "answers" => "4,quatre" }
      ]
  }
end
