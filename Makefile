API_PASSWORD := $(shell head -c 21 /dev/random | openssl base64 -nopad)
WALLET_PASSWORD := $(shell head -c 21 /dev/random | openssl base64 -nopad)
PG_PASSWORD := $(shell openssl rand -hex 15)

all:
	@echo "FROM smartcontract/chainlink" > Dockerfile
	@echo "" >> Dockerfile
	@echo "# Create the chainlink node root path" >> Dockerfile
	@echo "RUN mkdir /chainlink" >> Dockerfile
	@echo "" >> Dockerfile
	@echo "# Arg for api user email, with default value" >> Dockerfile
	@echo "ARG API_USER_EMAIL=\"user@example.com\"" >> Dockerfile
	@echo 'ENV API_USER_EMAIL=$$API_USER_EMAIL' >> Dockerfile
	@echo "" >> Dockerfile
	@echo "# Arg for api user password, with default value" >> Dockerfile
	@echo "ARG API_USER_PASSWORD=\"$(API_PASSWORD)\"" >> Dockerfile
	@echo 'ENV API_USER_PASSWORD=$$API_USER_PASSWORD' >> Dockerfile
	@echo "" >> Dockerfile
	@echo "# Arg for node wallet password, with default value" >> Dockerfile
	@echo "ARG WALLET_PASSWORD=\"$(WALLET_PASSWORD)\"" >> Dockerfile
	@echo 'ENV WALLET_PASSWORD=$$WALLET_PASSWORD' >> Dockerfile
	@echo "" >> Dockerfile
	@echo "# Create chainlink node required values to initialize with" >> Dockerfile
	@echo 'RUN echo $$API_USER_EMAIL > /chainlink/.api' >> Dockerfile
	@echo 'RUN echo $$API_USER_PASSWORD >> /chainlink/.api' >> Dockerfile
	@echo 'RUN echo $$WALLET_PASSWORD > /chainlink/.password' >> Dockerfile

	@echo "POSTGRES_PASSWORD=\"$(PG_PASSWORD)\"" > postgres.env
	@echo "POSTGRES_DB=chainlink" >> postgres.env

	@echo $(shell sed 's/REPLACEME/$(PG_PASSWORD)/' chainlink.env.sample > chainlink.env)

	@echo Your PostgreSQL password is: $(PG_PASSWORD)
	@echo Your ChainLink API password is: $(API_PASSWORD)
	@echo Your wallet password is: $(WALLET_PASSWORD)


clean:
	rm -f Dockerfile chainlink.env postgres.env
