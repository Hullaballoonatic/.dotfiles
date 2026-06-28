use actix_web::{web, App, HttpServer, Responder};
use std::process::Command;

async fn wake_desktop() -> impl Responder {
    Command::new("wake-desktop")
        .status()
        .map(|_| "Desktop awoken!")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new().service(
            web::scope("/api/v1")
                .service(
                    web::scope("/desktop")
                        .route("/wake", web::get().to(wake_desktop))
                )
        )
    })
    .bind(("0.0.0.0", 8787))?
    .run()
    .await
}

