class ContactsController < ApplicationController
  
  #Get request to /contact-us
  #Show new contact form
  def new
    @contact = Contact.new
  end
  
  # POST request /contacts
  def create
    # Mass assignment of form fields into COntact object
    @contact = Contact.new(contact_params)
    # Save the Contact object to database
    if @contact.save
      # Store form fields via paramaters, into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comment]
      # Plug variables into contact Mailer *Mailgun sub/ credit card info required
      # email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      # Store success message in flash hash
      # and redirect to the new action
      flash[:success] = "Message sent."
      redirect_to new_contact_path
    else
      # If Contact object doesnt save, 
      # store erros in flash hash,
      # and redirect to the new action
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end   
  
  private
    # To collect data from form, we need to use
    # Strong paramatersand whitelist the form fields
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end