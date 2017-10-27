# Terakeet Books

This Rails project was built by Casey Macaulay as a take-home coding assignment from Terakeet. This application provides a PSQL database for a fictional online bookstore.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

App setup:
```
git clone git@github.com:cmacaulay/terakeet-books.git
cd terakeet-books
bundle install
```
To create your local database:
```
rails db:create
rails db:migrate
```

## Running the tests

This application is tested using RSpec. To run the full test suite from your terminal, run the command:

```
rspec
```
## How did I approach this challenge?

To gain more in-depth insight of my thought process in working through this challenge, please see my [planning thoughts](PLANNING_THOUGHTS.md), which I typed out as I worked through different iterations of the project.

### Iteration 0: Book, Publisher & Author Model Set-up

The specs asked to build out a Book model. First, I determined what the minimum schema design would have to be in order to successfully set up the relationships defined in the books table.

![alt text](./public/images/author-publisher-book-schema.png "Schema: Iteration 0")

### Iteration 1: Finish the schema

With the relationships built for a successful books table, next I had to make sure the schema met the demands of the required instance methods. I realized we would need to add BookFormatType, BookFormat and BookReview models to our app, in order to create the instance methods.

![alt text](./public/images/final-schema.png "Final Schema")

### Iteration 2: Book Instance methods

With the schema finalized, it was then time for Book's instance methods. While I had used TDD to model-test before this iteration, I relied on it to really guide my development process starting with this iteration, to ensure the methods were returning what was expected.

### Iteration 3: Book Class method

This was the most challenging piece of the application, and I really enjoyed thinking through how to best query the database and organize how the search query and options were processed. At first, I didn't know where to begin. Then, I realized that there were smaller chunks of the puzzle I could address in isolation - each query rule, or each option for instance - and so I started my testing each of these pieces separately, which really came in handy when I was piecing it all together. Each of the query rules or the search options is applying their own rules to the database, and thinking of how they could work together modularly ended up being very helpful.

## What did I learn?

I really enjoyed this code challenge! Any new project should teach you a few things, here are some of the road bumps and lessons learned I had from this project:
* Never trust that your code environment is going to work, even if it worked yesterday!
** In starting the project, I ran into some versioning issues for both Rails and Ruby - always a good way to start!
* A gem you've always used may suddenly have a new name!
** Right before starting, FactoryGirl was changed to FactoryBot. This was confusing during set-up! Once I figured it out, I realized it's always a good idea to start with the docs, even if you've used sometime numerous times before.
* Testing is still one of my favorite ways to breakdown a problem.

## Resources referenced:

* (Active Record Docs)[http://guides.rubyonrails.org/active_record_querying.html#ids]
* Stack Overflow Questions (like this one)[https://stackoverflow.com/questions/29380941/ordering-data-from-table-by-average-rating-and-number-of-reviews-including-objec]
* (Blog Post on Scopes)[https://www.justinweiss.com/articles/search-and-filter-rails-models-without-bloating-your-controller/]
* (Factory Bot Docs)[https://github.com/thoughtbot/factory_bot_rails]
