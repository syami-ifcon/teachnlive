class StudentsController < ApplicationController
	def index
		@student = Student.all
	end

	def create
		@student = Student.new(first_name: params["student"]["first_name"], last_name: params["student"]["last_name"], phone: params["student"]["phone"], email: params["student"]["email"])
		@student.save
		redirect_to '/'
	end

	def create_from_omniauth
		# there is diffrent in param that is receive which it is in the hd params
	    auth_hash = request.env["omniauth.auth"]
	    # take lecture id
	    lecture_id = request.env["omniauth.params"]
	    # search for authentication object of the student
	    authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) ||  Authentication.create_with_omniauth(auth_hash)
	    if authentication.student
	    	# get student object by using the authentication object
		    student = authentication.student
		    authentication.update_token(auth_hash)
 	  		@attendance = Attendance.update(lecture_id: lecture_id["lecture_id"].to_i, student_id: authentication.student_id,present: true)
	    else
 	  		x = Student.find_by(email: auth_hash["info"]["email"])
 	  		if x
 	  			x.destroy
 	  			@student = Student.create_with_auth_and_hash(authentication, auth_hash)
 	  			@attendance = Attendance.create(lecture_id: lecture_id["lecture_id"].to_i, student_id: authentication.student_id,present: true)
			  	haha = Lecture.find(lecture_id["lecture_id"].to_i)
			  	flash[:success] = "You Successfully Attending #{haha.subject_name}"
 	  		else
	  			flash[:warning] = "See Your Administrator to Register with this credential"
 	  		end
 	  		byebug
	  	end
	  	redirect_to root_path
	end

	def new_student
		@list_lecture = Lecture.all
	end

	def sign_up
		cookies[:new_lecture] = params[:lecture_id]
		redirect_to "/auth/google_oauth2"
	end
end