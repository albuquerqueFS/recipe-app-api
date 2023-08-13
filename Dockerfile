FROM python:3.9-alpine3.13
LABEL maintainer="henrique_barretto@outlook.com"

# makes so that the python output should be printed without any buffering
ENV PYTHONUNBUFFERED 1

# Copies the requirements to inside the container
COPY ./requirements.txt /tmp/requirements.txt
# Copies the app folder to inside the ocntainer
COPY ./app /app
# Sets the working directory to the copied project directory
WORKDIR /app
# Exposes port 8000 from out container to our machine
EXPOSE 8000

# This giga run command is being formated with "&& \" to break a line
# We start by creating a virtual environment
RUN python -m venv /py && \
# Installing and upgrading pip
    /py/bin/pip install --upgrade pip && \
# Installing depencies from our requirements
    /py/bin/pip install -r /tmp/requirements.txt && \
# Removing the tmp folder after using it
# (ITS GOOD TO MAKE YOUR CONTAINER AS LIGHT AS POSSIBLE)
    rm -rf /tmp && \
# This adds a new user to inside our image
# (ITS GOOD PRACTICE TO NOT USE THE ROOT USER (SHIT CAN GO CRAZY IF YOU GET HACKED))
    adduser \
# NO PASSWORD
        --disabled-password \
# DOESN'T CREATE A HOME FOLDER FOR THE USER
        --no-create-home \
# USER NAME
        django-user

# SETS THE PATH TO BE THE CONTAINER BIN FOLDER
ENV PATH="/py/bin:$PATH"

# ACESSING AS THE CREATED USER
USER django-user