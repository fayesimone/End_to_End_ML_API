FROM python:3.11-slim AS builder
WORKDIR /app

RUN apt-get update \
    && apt-get install -y \
         curl \
         build-essential \
         libffi-dev \
    && rm -rf /var/lib/apt/lists/*

ENV POETRY_HOME=/opt/poetry
ENV POETRY_VERSION=1.7.1
ENV PATH="${POETRY_HOME}/bin:${PATH}"

RUN curl -sSL https://install.python-poetry.org | python3 -

COPY pyproject.toml poetry.lock ./
RUN python -m venv --copies /app/venv
RUN . /app/venv/bin/activate && poetry install --only main

FROM python:3.11-slim AS runner
WORKDIR /app

COPY --from=builder /app/venv /app/venv
ENV PATH="/app/venv/bin:${PATH}"

COPY . . 

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0"]