FROM python:3.12-slim AS generate-requirements

# Install curl (required to install Poetry)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Add poetry binary to PATH
ENV PATH="/root/.local/bin:$PATH"

# Copy dependency files
COPY pyproject.toml poetry.lock ./

# Install poetry-plugin-export (needed for Poetry v2.x)
RUN poetry self add poetry-plugin-export

# Generate requirements.txt
RUN poetry export --output requirements.txt

###

FROM python:3.12-slim AS production

# Copy the generated requirements.txt from the first stage
COPY --from=generate-requirements /requirements.txt .

# Install dependencies using pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy your application code
COPY . ./

# (Optional: Expose your application port here if required, e.g., EXPOSE 8000)

# Run your application entrypoint or specify your startup command
CMD ["python", "app.py"]
