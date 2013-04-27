require 'spec_helper'

describe MoviesController, :type => :controller do

  describe 'Editing an existing movie' do

    it 'should try to read the movie from the db' do
      Movie.should_receive(:find).with("123")
      get :edit, {:id => 123} 
    end


    it 'should show movie details' do
      m = mock('Movie')
      m.stub(:id => 123)
      m.stub(:title => 'My Fake Movie')
      Movie.stub(:find).and_return(m)

      get :edit, {:id => m.id}

      assigns(:movie).should == m
    end
  end

  describe 'Searching for similar movies' do

    context 'when movie has a director' do

      it 'should search for movies by director' do
        m = mock('Movie')
        m.stub(:id => 1)
        m.stub(:title => 'Alien')
        m.stub(:director).and_return('Ridley Scott')
       
        Movie.stub(:find).and_return(m)
      
        Movie.should_receive(:find_all_by_director).with(m.director)
      
        get :similar, {:id => m.id}
      end

      it 'should make movies available to template' do
        m1 = mock('Movie')
        m1.stub(:director).and_return("Big Fat Director")
        m2 = mock('Movie')

        fake_results = [m1, m2]

        Movie.stub(:find).and_return(m1)

        Movie.stub(:find_all_by_director).and_return(fake_results)

        get :similar, {:id => 1}

        assigns(:movies).should == fake_results
      end
    end

    context 'when movie has no director assigned' do
      def do_similar
        m = mock('Movie')
        m.stub(:id => 1)
        m.stub(:title => 'Alien')
        m.stub(:director => nil)
 
        Movie.stub(:find).and_return(m)     
        get :similar, {:id => m.id}
      end

      it 'should be redirect' do
        do_similar
        response.should be_redirect
      end

      it 'should redirect to index page' do
        do_similar
        
        #response.should render_template('index')

        response.should redirect_to(movies_url)      
      end

      it 'should show warning message' do
        do_similar

        flash[:warning].should =~ /.*has no director*/i
      end
    end
  end
end
