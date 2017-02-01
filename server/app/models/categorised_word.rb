# == Schema Information
#
# Table name: categorised_words
#
#  id              :integer          not null, primary key
#  type            :string(255)      not null
#  large_category  :integer          default("large_unknown"), not null
#  medium_category :integer          default("medium_unknown"), not null
#  detail_category :string(255)      not null
#  degree          :integer          default("unknown"), not null
#  body            :text(65535)      not null
#  from_url        :string(255)
#
# Indexes
#
#  index_categorised_words_on_from_url  (from_url)
#  word_categories_index                (large_category,medium_category,detail_category)
#

class CategorisedWord < ApplicationRecord
  enum large_category: {
    large_unknown: 0,
    feeling: 1,
    sense: 2,
    person: 3,
    living: 4,
    landscape: 5,
    food: 6,
  }

  enum medium_category: {
    medium_unknown: 0,
    joy: 100,
    anger: 101,
    sorrow: 102,
    loneliness: 103,
    fear: 104,
    embarrassed: 105,
    like: 106,
    hate: 107,
    depressed: 108,
    endure: 109,
    regret: 110,
    heartburn: 111,
    agitation: 112,
    excitement: 113,
    tension: 114,
    disturbed: 115,
    relieved: 116,
    surprise: 117,
    smile: 118,
    facial_expression: 119,
    complex_feeling: 120,
    other_mood: 121,
    feeling_unknown: 199,
    color: 200,
    light_and_shadow: 201,
    shape: 202,
    voice: 203,
    sound: 204,
    smell: 205,
    taste: 206,
    sensation: 207,
    feeling_temperature: 208,
    stimulation: 209,
    distance: 210,
    space: 211,
    time: 212,
    identical: 213,
    amount: 214,
    degree: 215,
    thinking: 216,
    danger: 217,
    atmosphere: 218,
    failure: 219,
    impression: 220,
    how_to_feel: 221,
    popularity: 222,
    conflict: 223,
    movement: 224,
    situation: 225,
    other_sense: 226,
    sense_unknown: 299,
    head: 300,
    hair: 301,
    forehead: 302,
    eyebrow: 303,
    eyelid: 304,
    eye: 305,
    ear: 306,
    nose: 307,
    cheek: 308,
    lip: 309,
    tooth: 310,
    mouth: 311,
    beard: 312,
    face: 313,
    neck: 314,
    laugh: 315,
    feeling_face: 316,
    memory: 317,
    in_head: 318,
    talk: 319,
    shoulder: 320,
    arm: 321,
    hand: 322,
    chest: 323,
    belly: 324,
    waist: 325,
    leg: 326,
    sex: 327,
    make_up: 328,
    child: 329,
    skin: 330,
    skin_condition: 331,
    body_shape: 332,
    human_impression: 333,
    bone: 334,
    body_smell: 335,
    clothing: 336,
    personality: 337,
    attitude: 338,
    watch: 339,
    walk: 340,
    attack: 341,
    behaviour: 342,
    pose: 343,
    breath: 344,
    sleep: 345,
    exchange_word: 346,
    word: 347,
    convey_satisfaction: 348,
    inform_dissatisfaction: 349,
    communication: 350,
    love: 351,
    person_unknown: 399,
    phone: 400,
    consumer_electronics: 401,
    weapon: 402,
    item: 403,
    learning: 404,
    accident: 405,
    occupation: 406,
    economy: 407,
    world: 408,
    human_relations: 409,
    health: 410,
    sport: 411,
    faith: 412,
    life: 413,
    life_and_death: 414,
    living_unknown: 499,
    spring: 500,
    summer: 501,
    autumn: 502,
    winter: 503,
    timezone: 504,
    land: 505,
    plant: 506,
    underwater: 507,
    hollow: 508,
    road: 509,
    room_atmosphere: 510,
    artifacts: 511,
    building: 512,
    facility: 513,
    vehicle: 514,
    entertainment: 515,
    sunny: 516,
    thunder: 517,
    frost: 518,
    natural_disaster: 519,
    rain: 520,
    temperature: 521,
    wind: 522,
    animal: 523,
    insect: 524,
    fire: 525,
    phenomenon: 526,
    landscape_unknown: 599,
    rice: 600,
    noodle: 601,
    bread: 602,
    texture: 603,
    vegetable: 604,
    bean: 605,
    potato: 606,
    wild_vegetable: 607,
    fruit: 608,
    nut_and_seed: 609,
    mushroom: 610,
    seaweed: 611,
    fish: 612,
    shellfish: 613,
    other_seafood: 614,
    fish_dishes: 615,
    meat: 616,
    meat_dishes: 617,
    egg: 618,
    milk: 619,
    seasoning: 620,
    sweetener: 621,
    spice: 622,
    japanese_confectionery: 623,
    confectionery: 624,
    alcoholic_beverage: 625,
    soft_drink: 626,
    tea: 627,
    japanese_cuisine: 628,
    chinese_cuisine: 629,
    western_cuisine: 630,
    cooking: 631,
    food_unknown: 699,
  }

  enum degree: [:unknown, :very_low, :low, :normal, :high, :ver_high]
end
