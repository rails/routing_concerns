Routing Concerns
================

Abstract common routing resource concerns to cut down on duplication.

Code before:

```ruby
BCX::Application.routes.draw do
  resources :calendar_events do
    get :past, on: :collection
    resources :comments
  end

  resources :messages  { resources :comments }
  resources :forwards  { resources :comments }
  resources :uploads   { resources :comments }
  resources :documents { resources :comments }
  resources :todos     { resources :comments }
  
  resources :projects, defaults: { bucket_type: 'project' } do
    post :trash, :restore, on: :member
  
    resources :messages, except: [ :new ] do
      post :trash, :restore, on: :member
      resources :image_attachments, only: :index
    end
  
    resources :forwards do
      member do
        get  :content
        post :trash, :restore
      end
  
      resources :image_attachments, only: :index
    end
  
    resources :uploads do
      post :trash, :restore, on: :member
      resources :image_attachments, only: :index
    end
  
    resources :todolists do
      get :more, :completed, on: :collection
      post :trash, :restore, on: :member
    end
  
    resources :todos do
      post :toggle, :trash, :restore, on: :member
    end
  
    resources :comments do
      post :trash, on: :member
      resources :image_attachments, only: :index
    end
  end
end
```

Code after:

```ruby
BCX::Application.routes.draw do
  concern :commentable do
    resources :comments
  end
  
  concern :trashable do
    post :trash, :restore, on: :member
  end

  concern :image_attachable do
    resources :image_attachments, only: :index
  end

  resources :calendar_events, concerns: :commentable do
    get :past, on: :collection
  end

  resources :messages, :forwards, :uploads, :documents, :todos, concerns: :commentable

  resources :projects, concerns: :trashable, defaults: { bucket_type: 'project' } do
    resources :messages, :uploads, :comments, concerns: [:trashable, :image_attachable]
  
    resources :forwards, concerns: [:trashable, :image_attachable] do
      get :content, on: :member
    end
  
    resources :todolists, concerns: :trashable do
      get :more, :completed, on: :collection
    end
  
    resources :todos, concerns: :trashable do
      post :toggle, on: :member
    end
  end
end
```

Compatibility
-------------

This plugin was designed as a proof-of-concept for a feature that's destined for Rails 4. It has only been tested on Rails 3.2+, but may work on earlier versions as well.